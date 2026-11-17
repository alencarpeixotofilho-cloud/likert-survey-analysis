# Charts ---------------------------------------------------------------------

LIKERT_COLORS <- c("#b2182b", "#ef8a62", "#d9d9d9", "#67a9cf", "#2166ac")

#' Diverging stacked bar chart: disagreement to the left, agreement to the
#' right, neutral split around zero. Items are sorted by % agreement.
plot_likert <- function(long, title = "Responses by item") {
  d <- long |>
    dplyr::filter(!is.na(value)) |>
    dplyr::count(dimension, item, text, value) |>
    dplyr::group_by(item) |>
    dplyr::mutate(pct = 100 * n / sum(n)) |>
    dplyr::ungroup()
  agree <- d |>
    dplyr::group_by(item) |>
    dplyr::summarise(agree = sum(pct[value >= 4]), .groups = "drop")
  d <- dplyr::left_join(d, agree, by = "item")
  d$label <- factor(LIKERT_LABELS[d$value], levels = LIKERT_LABELS)
  d$wrapped <- stringr_wrap(paste0(d$item, ". ", d$text), 48)
  d$wrapped <- stats::reorder(d$wrapped, d$agree)

  neg <- d |>
    dplyr::filter(value <= 3) |>
    dplyr::mutate(pct = ifelse(value == 3, -pct / 2, -pct))
  pos <- d |>
    dplyr::filter(value >= 3) |>
    dplyr::mutate(pct = ifelse(value == 3, pct / 2, pct))
  # position_stack places the first factor level farthest from zero, so the
  # extremes go first and the neutral half-bar sits next to the axis
  neg$label <- factor(neg$label, levels = LIKERT_LABELS[1:3])
  pos$label <- factor(pos$label, levels = rev(LIKERT_LABELS[3:5]))

  ggplot2::ggplot() +
    ggplot2::geom_col(data = neg, ggplot2::aes(pct, wrapped, fill = label), width = 0.7) +
    ggplot2::geom_col(data = pos, ggplot2::aes(pct, wrapped, fill = label), width = 0.7) +
    ggplot2::geom_vline(xintercept = 0, colour = "grey30", linewidth = 0.3) +
    ggplot2::scale_fill_manual(values = setNames(LIKERT_COLORS, LIKERT_LABELS),
                               breaks = LIKERT_LABELS, name = NULL) +
    ggplot2::scale_x_continuous(labels = function(x) paste0(abs(x), "%"),
                                limits = c(-100, 100)) +
    ggplot2::facet_grid(dimension ~ ., scales = "free_y", space = "free_y") +
    ggplot2::labs(x = NULL, y = NULL, title = title) +
    ggplot2::theme_minimal(base_size = 10) +
    ggplot2::theme(legend.position = "top", panel.grid.major.y = ggplot2::element_blank(),
                   strip.text.y = ggplot2::element_text(angle = 0, face = "bold"),
                   plot.title.position = "plot")
}

#' Dimension index by group with 95% CI.
plot_dimensions <- function(dim_summary, group = "program") {
  d <- dim_summary[!is.na(dim_summary$index), ]
  ggplot2::ggplot(d, ggplot2::aes(index, dimension, colour = .data[[group]])) +
    ggplot2::geom_vline(xintercept = 50, linetype = 2, colour = "grey60") +
    ggplot2::geom_pointrange(ggplot2::aes(xmin = lower, xmax = upper),
                             position = ggplot2::position_dodge(width = 0.6)) +
    ggplot2::scale_x_continuous(limits = c(0, 100)) +
    ggplot2::labs(x = "Satisfaction index (0-100)", y = NULL, colour = NULL,
                  title = "Dimension index by group (95% CI)") +
    ggplot2::theme_minimal(base_size = 10) +
    ggplot2::theme(legend.position = "top", plot.title.position = "plot")
}

stringr_wrap <- function(x, width) {
  vapply(x, function(s) paste(strwrap(s, width), collapse = "\n"), character(1))
}

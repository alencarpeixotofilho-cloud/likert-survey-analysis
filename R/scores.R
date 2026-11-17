# Scoring of Likert items and dimensions -----------------------------------

LIKERT_LABELS <- c("Strongly disagree", "Disagree", "Neutral", "Agree", "Strongly agree")

#' Reshape wide responses to long format and attach the questionnaire.
to_long <- function(responses, questionnaire, id_cols = c("respondent", "cycle", "program", "term")) {
  items <- questionnaire$item
  long <- tidyr::pivot_longer(responses, dplyr::all_of(items),
                              names_to = "item", values_to = "value")
  dplyr::left_join(long, questionnaire, by = "item")
}

#' Item-level summary: n, mean, % agreement (top-2 box) and a 0-100 index.
#'
#' The satisfaction index rescales the mean from [1, 5] to [0, 100]:
#' index = 100 * (mean - 1) / 4.
item_summary <- function(long, ...) {
  long |>
    dplyr::filter(!is.na(value)) |>
    dplyr::group_by(..., dimension, item, text) |>
    dplyr::summarise(
      n = dplyr::n(),
      mean = mean(value),
      sd = stats::sd(value),
      agree_pct = 100 * mean(value >= 4),
      disagree_pct = 100 * mean(value <= 2),
      index = 100 * (mean(value) - 1) / 4,
      .groups = "drop"
    )
}

#' Dimension scores: average of each respondent's item mean within the
#' dimension (respondents need at least `min_items` answered items).
dimension_scores <- function(long, min_items = 2) {
  long |>
    dplyr::filter(!is.na(value)) |>
    dplyr::group_by(respondent, cycle, program, term, dimension) |>
    dplyr::summarise(k = dplyr::n(), score = mean(value), .groups = "drop") |>
    dplyr::filter(k >= min_items) |>
    dplyr::mutate(index = 100 * (score - 1) / 4)
}

#' Dimension summary by group with a 95% confidence interval for the index.
dimension_summary <- function(dim_scores, ...) {
  dim_scores |>
    dplyr::group_by(..., dimension) |>
    dplyr::summarise(
      n = dplyr::n(),
      se = stats::sd(index) / sqrt(dplyr::n()),
      index = mean(index),
      .groups = "drop"
    ) |>
    dplyr::mutate(lower = index - 1.96 * se, upper = index + 1.96 * se)
}

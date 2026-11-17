# Internal consistency ------------------------------------------------------

#' Cronbach's alpha for a numeric matrix/data frame (complete cases).
cronbach_alpha <- function(x) {
  x <- stats::na.omit(as.data.frame(x))
  k <- ncol(x)
  if (k < 2 || nrow(x) < 3) return(NA_real_)
  item_var <- sum(vapply(x, stats::var, numeric(1)))
  total_var <- stats::var(rowSums(x))
  k / (k - 1) * (1 - item_var / total_var)
}

#' Corrected item-total correlation for every item of a scale.
item_total <- function(x) {
  x <- stats::na.omit(as.data.frame(x))
  vapply(names(x), function(i) {
    stats::cor(x[[i]], rowSums(x[setdiff(names(x), i)]))
  }, numeric(1))
}

#' Reliability table: one row per dimension.
reliability_table <- function(responses, questionnaire) {
  dims <- unique(questionnaire$dimension)
  do.call(rbind, lapply(dims, function(d) {
    items <- questionnaire$item[questionnaire$dimension == d]
    x <- responses[items]
    it <- item_total(x)
    data.frame(
      dimension = d,
      items = length(items),
      complete_cases = nrow(stats::na.omit(x)),
      alpha = round(cronbach_alpha(x), 3),
      min_item_total = round(min(it), 3),
      weakest_item = names(it)[which.min(it)]
    )
  }))
}

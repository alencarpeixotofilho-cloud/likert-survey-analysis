# Anonymity protection --------------------------------------------------------

#' Suppress results for groups with fewer than `min_n` respondents.
#'
#' Small groups make individual answers identifiable (e.g. a program with
#' four students). Numeric columns of suppressed rows are set to NA and a
#' `suppressed` flag is added so reports can display "n < min_n".
suppress_small_groups <- function(summary, min_n = 10, n_col = "n") {
  small <- summary[[n_col]] < min_n
  num <- vapply(summary, is.numeric, logical(1))
  num[n_col] <- FALSE
  summary[small, num] <- NA
  summary$suppressed <- small
  summary
}

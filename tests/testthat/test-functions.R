root <- normalizePath(file.path(testthat::test_path(), "..", ".."))
for (f in c("scores.R", "reliability.R", "suppression.R", "plots.R")) source(file.path(root, "R", f))

test_that("cronbach_alpha matches a hand-computed value", {
  x <- data.frame(a = c(1, 2, 3, 4, 5), b = c(2, 2, 3, 5, 5), c = c(1, 3, 3, 4, 4))
  k <- 3
  expected <- k / (k - 1) * (1 - sum(sapply(x, var)) / var(rowSums(x)))
  expect_equal(cronbach_alpha(x), expected)
})

test_that("alpha is NA with fewer than two items", {
  expect_true(is.na(cronbach_alpha(data.frame(a = 1:5))))
})

test_that("small groups are suppressed and flagged", {
  s <- data.frame(program = c("A", "B"), n = c(50, 4), index = c(70, 90))
  out <- suppress_small_groups(s, min_n = 10)
  expect_true(is.na(out$index[2]))
  expect_equal(out$index[1], 70)
  expect_equal(out$suppressed, c(FALSE, TRUE))
  expect_equal(out$n, c(50, 4))
})

test_that("index rescales 1-5 to 0-100", {
  q <- data.frame(item = c("X1", "X2"), dimension = "D", text = c("t1", "t2"))
  r <- data.frame(respondent = c("r1", "r2"), cycle = "2026", program = "A", term = 1,
                  X1 = c(1, 5), X2 = c(1, 5))
  long <- to_long(r, q)
  s <- item_summary(long)
  expect_equal(s$index, c(50, 50))
  d <- dimension_scores(long)
  expect_equal(sort(d$index), c(0, 100))
})

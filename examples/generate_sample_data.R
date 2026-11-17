# Generate synthetic survey responses (no real data involved).
#
# Respondents belong to programs and terms; each has a latent satisfaction
# level per dimension. Answers on a 5-point Likert scale are obtained by
# cutting a latent normal variable at fixed thresholds. One program is
# deliberately small so the anonymity-suppression rule has something to do.
#
# Usage:  Rscript examples/generate_sample_data.R

set.seed(2026)

questionnaire <- read.csv("questionnaires/questionnaire.csv", stringsAsFactors = FALSE)
programs <- c("Program A" = 180, "Program B" = 140, "Program C" = 95, "Program D" = 4)
dims <- unique(questionnaire$dimension)

# program x dimension effects (latent scale)
effects <- matrix(rnorm(length(programs) * length(dims), 0, 0.35),
                  nrow = length(programs), dimnames = list(names(programs), dims))
effects[, "Infrastructure"] <- effects[, "Infrastructure"] - 0.5   # a weaker dimension
effects["Program B", "Assessment"] <- effects["Program B", "Assessment"] - 0.6
cycle_shift <- c("2025" = 0, "2026" = 0.15)

cuts <- c(-Inf, -1.6, -0.7, 0.1, 1.0, Inf)
rows <- list()
id <- 0
for (cycle in names(cycle_shift)) {
  for (p in names(programs)) {
    n <- programs[[p]] + if (cycle == "2026") round(programs[[p]] * 0.1) else 0
    for (i in seq_len(n)) {
      id <- id + 1
      person <- rnorm(1, 0.6, 0.6)
      term <- sample(1:8, 1)
      ans <- vapply(seq_len(nrow(questionnaire)), function(j) {
        d <- questionnaire$dimension[j]
        z <- person + effects[p, d] + cycle_shift[[cycle]] + rnorm(1, 0, 0.8)
        as.integer(cut(z, cuts, labels = FALSE))
      }, integer(1))
      ans[runif(length(ans)) < 0.03] <- NA          # item non-response
      rows[[length(rows) + 1]] <- c(list(respondent = sprintf("R%05d", id),
                                         cycle = cycle, program = p, term = term),
                                    setNames(as.list(ans), questionnaire$item))
    }
  }
}
responses <- do.call(rbind.data.frame, rows)
dir.create("examples/data", showWarnings = FALSE, recursive = TRUE)
write.csv(responses, "examples/data/responses.csv", row.names = FALSE)
cat(nrow(responses), "synthetic respondents written to examples/data/responses.csv\n")

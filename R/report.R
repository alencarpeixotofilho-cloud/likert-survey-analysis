# Render the full report -------------------------------------------------------
#
# Usage (from the repository root):
#   Rscript examples/generate_sample_data.R
#   Rscript R/report.R
#
# Produces docs/report.html plus PNG figures in docs/.

for (f in c("R/scores.R", "R/reliability.R", "R/suppression.R", "R/plots.R")) source(f)

questionnaire <- read.csv("questionnaires/questionnaire.csv", stringsAsFactors = FALSE)
responses <- read.csv("examples/data/responses.csv", stringsAsFactors = FALSE)
responses$cycle <- as.character(responses$cycle)
long <- to_long(responses, questionnaire)

dir.create("docs", showWarnings = FALSE)
ggplot2::ggsave("docs/likert_items.png",
                plot_likert(dplyr::filter(long, cycle == "2026"), "Responses by item - 2026 cycle"),
                width = 9, height = 7.5, dpi = 130, bg = "white")

dims <- dimension_scores(long)
by_program <- dimension_summary(dplyr::filter(dims, cycle == "2026"), program) |>
  suppress_small_groups(min_n = 10)
ggplot2::ggsave("docs/dimensions_by_program.png", plot_dimensions(by_program),
                width = 8, height = 4.2, dpi = 130, bg = "white")

rmarkdown::render("report/report.Rmd", output_dir = "docs", output_file = "report.html",
                  knit_root_dir = getwd(), quiet = TRUE,
                  params = list(responses = "examples/data/responses.csv",
                                questionnaire = "questionnaires/questionnaire.csv",
                                min_n = 10))
cat("Report written to docs/report.html\n")

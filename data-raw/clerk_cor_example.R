## code to prepare `clerk_cor_example` dataset
## Synthetic partial correlation results (age + sex controlled).
## All values are simulated — no real participant data.

set.seed(123)

predictors <- c("hdl", "glucose", "bmi", "waist", "systolic_bp",
                "bdi", "panas_neg", "life_satisfaction")

outcomes <- c("tmt_time", "verbal_fluency")

clerk_cor_example <- expand.grid(
  variable = predictors,
  outcome  = outcomes,
  stringsAsFactors = FALSE
)

clerk_cor_example$n <- sample(240:300, nrow(clerk_cor_example), replace = TRUE)
clerk_cor_example$r <- round(runif(nrow(clerk_cor_example), -0.25, 0.25), 3)
clerk_cor_example$p <- round(runif(nrow(clerk_cor_example), 0.001, 0.5), 3)

# Make a handful of results clearly significant for illustration
sig_idx <- c(1, 4, 7, 10)
clerk_cor_example$r[sig_idx] <- round(runif(length(sig_idx), 0.15, 0.30), 3)
clerk_cor_example$p[sig_idx] <- round(runif(length(sig_idx), 0.001, 0.01), 3)

usethis::use_data(clerk_cor_example, overwrite = TRUE)

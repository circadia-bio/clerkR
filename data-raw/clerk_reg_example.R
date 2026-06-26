## code to prepare `clerk_reg_example` dataset
## Synthetic linear regression results (outcome: TMT time, log-scale).
## Mimics broom::tidy() output. All values simulated.

set.seed(42)

terms <- c("bmi", "waist", "systolic_bp", "bdi", "panas_neg",
           "age", "sexMale")

clerk_reg_example <- data.frame(
  term      = terms,
  estimate  = round(c(0.021, -0.018, 0.012, 0.008, 0.015, 0.003, -0.045), 3),
  std.error = round(runif(length(terms), 0.005, 0.025), 3),
  conf.low  = NA_real_,
  conf.high = NA_real_,
  p.value   = round(c(0.012, 0.048, 0.210, 0.330, 0.041, 0.610, 0.003), 3),
  stringsAsFactors = FALSE
)

clerk_reg_example$conf.low  <- round(
  clerk_reg_example$estimate - 1.96 * clerk_reg_example$std.error, 3
)
clerk_reg_example$conf.high <- round(
  clerk_reg_example$estimate + 1.96 * clerk_reg_example$std.error, 3
)

usethis::use_data(clerk_reg_example, overwrite = TRUE)

## code to prepare `clerk_h2_example` dataset
## Synthetic heritability results matching herit_batch() output column names.
## All values simulated.

set.seed(7)

traits <- c("K (tension)", "S (shape)", "I (isometric)")
models <- c("unadj", "cov1", "cov2", "cov3")

clerk_h2_example <- expand.grid(
  trait      = traits,
  covariates = models,
  stringsAsFactors = FALSE
)

base_h2 <- c(0.46, 0.73, 0.47)
adj_h2  <- c(0.63, 0.82, 0.68)

clerk_h2_example$h2 <- round(
  ifelse(clerk_h2_example$covariates == "unadj",
         rep(base_h2, each = 1),
         rep(adj_h2,  each = 1)) +
    runif(nrow(clerk_h2_example), -0.02, 0.02),
  2
)

clerk_h2_example$ci_lo    <- round(pmax(0, clerk_h2_example$h2 -
                               runif(nrow(clerk_h2_example), 0.15, 0.22)), 2)
clerk_h2_example$ci_hi    <- round(pmin(1, clerk_h2_example$h2 +
                               runif(nrow(clerk_h2_example), 0.15, 0.22)), 2)
clerk_h2_example$pval     <- round(runif(nrow(clerk_h2_example), 0.0001, 0.001), 4)
clerk_h2_example$sigma2_a <- round(clerk_h2_example$h2 * 0.65, 3)
clerk_h2_example$sigma2_e <- round((1 - clerk_h2_example$h2) * 0.65, 3)

usethis::use_data(clerk_h2_example, overwrite = TRUE)

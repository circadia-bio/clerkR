## code to prepare `clerk_example` dataset
## All values are simulated — no real participant data.

set.seed(42)
n <- 300

sex <- factor(sample(c("Female", "Male"), n, replace = TRUE, prob = c(0.63, 0.37)))

clerk_example <- data.frame(
  sex              = sex,
  age              = round(rnorm(n, mean = 47, sd = 15), 1),
  # Metabolic
  hdl              = round(rnorm(n,
                                 mean = ifelse(sex == "Female", 50, 43),
                                 sd   = 10), 2),
  glucose          = round(rnorm(n, mean = 92, sd = 23), 1),
  bmi              = round(rnorm(n,
                                 mean = ifelse(sex == "Female", 26.5, 25.5),
                                 sd   = 5), 1),
  # Anthropometric
  waist            = round(rnorm(n, mean = 92, sd = 12), 1),
  systolic_bp      = round(rnorm(n,
                                 mean = ifelse(sex == "Female", 120, 129),
                                 sd   = 17), 0),
  # Cognitive
  tmt_time         = round(exp(rnorm(n, mean = 4.76, sd = 0.48)), 1),
  verbal_fluency   = round(rnorm(n, mean = 14.7, sd = 4.7), 0),
  # Mental health
  bdi              = round(pmax(0, rnorm(n,
                                         mean = ifelse(sex == "Female", 15, 9),
                                         sd   = 10)), 0),
  panas_neg        = round(rnorm(n,
                                 mean = ifelse(sex == "Female", 23, 19),
                                 sd   = 7), 0),
  life_satisfaction = round(rnorm(n,
                                  mean = ifelse(sex == "Female", 17.4, 19.2),
                                  sd   = 3.9), 0)
)

usethis::use_data(clerk_example, overwrite = TRUE)

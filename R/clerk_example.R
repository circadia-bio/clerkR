#' Synthetic example dataset for clerkR
#'
#' @description
#' A synthetic dataset of 300 participants with demographic, metabolic,
#' anthropometric, cognitive, and mental health variables, designed to
#' illustrate `tbl_descriptive()` and other `clerkR` table constructors.
#' All values are simulated and bear no relation to any real study.
#'
#' @format A data frame with 300 rows and 12 variables:
#' \describe{
#'   \item{sex}{Factor: `"Female"` / `"Male"`.}
#'   \item{age}{Age in years (numeric).}
#'   \item{hdl}{HDL cholesterol in mmol/L (numeric).}
#'   \item{glucose}{Fasting glucose in mmol/L (numeric).}
#'   \item{bmi}{Body mass index in kg/m² (numeric).}
#'   \item{waist}{Waist circumference in cm (numeric).}
#'   \item{systolic_bp}{Systolic blood pressure in mmHg (numeric).}
#'   \item{tmt_time}{Trail Making Test completion time in seconds, log-scale
#'     analysis recommended (numeric).}
#'   \item{verbal_fluency}{Verbal fluency score — number of words in 60 s
#'     (numeric).}
#'   \item{bdi}{Beck Depression Inventory total score (numeric).}
#'   \item{panas_neg}{PANAS negative affect subscale score (numeric).}
#'   \item{life_satisfaction}{Life Satisfaction Scale total score (numeric).}
#' }
#' @source Simulated data generated in `data-raw/clerk_example.R`.
"clerk_example"

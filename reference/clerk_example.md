# Synthetic example dataset for clerkR

A synthetic dataset of 300 participants with demographic, metabolic,
anthropometric, cognitive, and mental health variables, designed to
illustrate
[`tbl_descriptive()`](https://clerkr.circadia-lab.uk/reference/tbl_descriptive.md)
and other `clerkR` table constructors. All values are simulated and bear
no relation to any real study.

## Usage

``` r
clerk_example
```

## Format

A data frame with 300 rows and 12 variables:

- sex:

  Factor: `"Female"` / `"Male"`.

- age:

  Age in years (numeric).

- hdl:

  HDL cholesterol in mmol/L (numeric).

- glucose:

  Fasting glucose in mmol/L (numeric).

- bmi:

  Body mass index in kg/m² (numeric).

- waist:

  Waist circumference in cm (numeric).

- systolic_bp:

  Systolic blood pressure in mmHg (numeric).

- tmt_time:

  Trail Making Test completion time in seconds, log-scale analysis
  recommended (numeric).

- verbal_fluency:

  Verbal fluency score — number of words in 60 s (numeric).

- bdi:

  Beck Depression Inventory total score (numeric).

- panas_neg:

  PANAS negative affect subscale score (numeric).

- life_satisfaction:

  Life Satisfaction Scale total score (numeric).

## Source

Simulated data generated in `data-raw/clerk_example.R`.

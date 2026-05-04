# ==========================================
# MAIN PIPELINE
# ==========================================

library(here)
library(dplyr)
library(assertthat)
library(testthat)
library(lme4)
library(lmerTest)
library(fixest)

# Central package loading only happens here.

# Global settings and simulation inputs
set.seed(123)
config <- list(

#Seeds must not overlap to remove unintended correlations between different stages of the simulation.

  school_seed = 123,
  pupil_seed = 456,
  randomisation_seed = 789,
  results_seed = 101112,

  sample_size = 103,
  usual_practice_pupils = 4141,
  YAM_pupils = 4028,
  pupil_sample_bounds = c(55, 95),

#The spread of the school variables
  school_fsm_binomial_size = 100,
  prior_mh_support_prob = 0.52,

  gender_levels = c("Male", "Female"),
  gender_probs = c(0.50, 0.50),
  ethnicity_levels = c("Broad White", "Ethnic Minority Groups"),
  ethnicity_probs = c(0.603, 0.397),
  previous_poor_mh_levels = c("SMFQ above cutoff", "Below cutoff"),
  previous_poor_mh_probs = c(0.203, 0.797),
  sen_levels = c("SEN", "No SEN"),
  sen_probs = c(0.196, 0.804),
  fsm_levels = c("FSM", "No FSM"),

#Trial and ransdomisation parameters
  n_treatment = 51,
  n_control = 52,
  minimisation_prob = 0.9,

#Parameters for simulating the results
  compliance_levels = c("Complier", "Non-complier"),
  compliance_probs = c(0.78, 0.22),
  baseline_sd = 5,
  threshold = 12,
  target_prop_above = 0.203,
  score_min = 0,
  score_max = 26,
  control_change_mean = -0.5,
  control_change_sd = 3,
  treatment_change_mean = -2,
  treatment_change_sd = 3,
  moderators = c(
    "gender",
    "fsm_tertile",
    "ethnicity",
    "previous_poor_mh",
    "sen_status",
    "urban_rural_simple",
    "prior_mh_support"
  )
)

#Source all function files. 
source(here("R", "01_data_prep.R")) 
source(here("R", "02_simulate_schools.R")) 
source(here("R", "03_simulate_pupils.R")) 
source(here("R", "04_simplify_school_vars.R")) 
source(here("R", "05_sampling.R"))
source(here("R", "06_minimisation.R"))
source(here("R", "07_sim_school_treatment.R"))
source(here("R", "08_sample_pupils.R"))
source(here("R", "09_join_tables.R"))
source(here("R", "10_sim_outcome.R"))
source(here("R", "11_primary_outcome_analysis.R")) 
source(here("R", "12_moderator_analysis.R")) 
source(here("R", "13_cace_analysis.R"))

# Wrapper function to orchestrate all outcome simulation steps (07-10)
simulate_results <- function(schools_trial, pupils, config) {
  schools_processed <- run_school_treatment(schools_trial, config)
  pupils_sampled <- sample_pupils_within_schools(pupils, schools_processed)
  pupils_joined <- join_pupil_school_data(pupils_sampled, schools_processed)
  pupils_outcomes <- run_sim_outcome(pupils_joined, config)
  pupils_outcomes
}

# 1. Prepare aggregates
inputs <- prepare_data(here("data-raw", "schools_raw.csv"))

# Could be deleted?
config$fsm_percentage <- inputs$fsm_percentage
config$fsm_probs <- c(config$fsm_percentage, 1 - config$fsm_percentage)

# 2. Simulate schools, ensure the data exists and is unique.
schools <- simulate_schools(
  inputs$regional_totals,
  inputs$urban_rural_school_counts,
  inputs$total_schools,
  inputs$total_pupils,
  config = config
)

# 3. Simulate pupils and ensure that each of them have a school ID.
pupils <- simulate_pupils(
  schools,
  inputs$total_pupils,
  config = config
)

# 4. Simplify variables for minimisation
schools_simplified <- simplify_vars(schools, pupils)

# 5.Sampling (for now)
schools_sampled <- sample_schools(schools_simplified, config)

# 6. Minimisation algorithm
schools_minimised <- minimise_schools(
  schools_sampled,
  config = config
)

#7. Simulate school implementation, treatment and pupil counts
schools_treatment <- run_school_treatment(
  schools_minimised, 
  config
)

#8.Sample needed pupils within schools
pupils_sampled <- sample_pupils_within_schools(
  pupils,
  schools_treatment
)

#9. Join sampled pupils and school data
joined_data <- join_pupil_school_data(
  pupils_sampled,
  schools_treatment
)

# 10.  Simulate the results
results_data <- run_sim_outcome(
  joined_data,
  config
)

# 11. Primary outcome analysis
primary_results <- primary_outcome(results_data)
head(primary_results)

# 12. Moderator analysis
moderator_results <- run_moderator_analysis(
  results_data,
  config = config
)

# 13. Cace analysis
cace_results <- run_cace_analysis(
  results_data,
  config = config
)

print(head(cace_results))




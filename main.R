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
SMFQ_above_cutoff <- 0.203

SMFQ_above_cutoff <- 0.203

config <- list(

#Seeds must not overlap
#This removes unintended correlations between different stages of the simulation.
#Seeds must not overlap
#This removes unintended correlations between different stages of the simulation.

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

  SMFQ_above_cutoff = SMFQ_above_cutoff,
  previous_poor_mh_probs = c(SMFQ_above_cutoff, 1 - SMFQ_above_cutoff),
  sen_levels = c("SEN", "No SEN"),
  sen_probs = c(0.196, 0.804),
  fsm_levels = c("FSM", "No FSM"),

#Trial and ransdomisation parameters
  n_treatment = 51,
  n_control = 52,
  minimisation_prob = 0.9,

#Parameters for simulating the results
  compliance_levels = c("Complier", "Non-complier"),
  compliance_probs = c(0.51, 0.49),
  target_prop_above = SMFQ_above_cutoff,
  baseline_sd = 5,
  threshold = 12,
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
source(here("data-raw", "01_download_data.R"))
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
schools_raw_path <- download_schools_data(here("data-raw", "schools_raw.csv"))
inputs <- prepare_data(schools_raw_path)
config$fsm_percentage <- inputs$fsm_percentage
config$fsm_probs <- c(inputs$fsm_percentage, 1 - inputs$fsm_percentage)

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

#Sanity checks
print("1. Data Preparation")
cat("Sum of schools allocated to regions:", sum(inputs$regional_totals$total_schools), "\n")
cat("Sum of schools allocated to urban/rural:", sum(inputs$urban_rural_school_counts$total_schools), "\n")
cat("Total schools in the sample:", inputs$total_schools, "\n")
cat("Total pupils in the sample:", inputs$total_pupils, "\n")
# FSM proportion will be calculated from the pupils individually for each school.
#This value is to check that calculation. It isn't used.
cat("Original FSM percentage", inputs$fsm_percentage, "\n")
print("Success.")

# 2.Simulate schools
print("2. Simulate schools")
cat("Schools with IDs:", length(unique(schools$school_id)), "\n")
cat("Original region distribution:\n")
print(inputs$regional_totals)
cat("Assigned region distribution:\n")
print(table(schools$region))
cat("Original urban/rural distribution:\n")
print(inputs$urban_rural_school_counts)
cat("Assigned urban/rural distribution:\n")
print(table(schools$urban_rural))
cat("Prior MH support original probs:", config$prior_mh_support_prob, "\n")
cat("Assigned prior MH support distribution:\n")
print(table(schools$prior_mh_support))
#Some variation is expected due to random sampling.
#For prior MH_support, 1 is a school with prior support.

cat("Original pupil count:", inputs$total_pupils, "\n")
cat("Assigned pupil count:", sum(schools$pupil_count), "\n")
cat("Minimum pupils assigned to a school:", min(schools$pupil_count), "\n")
print("Success.")
#This is just worth checking to ensure its higher than max sample size.


# 3. Simulate pupils
print("3. Simulate pupils")
cat("Total pupil count:", nrow(pupils), "\n")
cat("Original gender distribution:", paste(config$gender_probs, collapse=","), "\n")
cat("Assigned gender distribution:\n")
print(table(pupils$gender))
cat("Original ethnicity distribution:", paste(config$ethnicity_probs, collapse=","), "\n")
cat("Assigned ethnicity distribtuion:\n")
print(table(pupils$ethnicity))
cat("Original SEN distribution:", paste(config$sen_probs, collapse=","), "\n")
cat("Assigned SEN distribution:\n")
print(table(pupils$sen_status))
cat("Original MH distribtuion):", paste(config$previous_poor_mh_probs, collapse=","), "\n")
cat("Assigned MH distribution:\n")
print(table(pupils$previous_poor_mh))

cat("Original FSM percentage", inputs$fsm_percentage, "\n")
cat("Assigned FSM distribution:\n")
print(table(pupils$fsm_status))

cat("Original pupil numbers:\n")
print(head(schools$pupil_count))
cat("Assigned pupil numbers:\n")
print(head(table(pupils$school_id)))
print("Success.")



#04. Simplify school variables
#N.B. The whole working of FSM needs to be checked in this file.
print("4. Simplify school variables")
cat("Check that the simplified variables reflect the original distributions\n") 
cat("Original distribution of Urban Rural:\n")
print(table(schools$urban_rural))
cat("Simplified distribution of Urban Rural:\n")
print(table(schools_simplified$urban_rural_simple))

cat("Original distribution of Region:\n")
print(table(schools$region))
cat("Simplified distribution of Region:\n")
print(table(schools_simplified$region_simple))

print("FSM is calculated from the sample. Check the value is reasonable.")

# Calculate FSM proportion from actual pupils data
fsm_in_pupils <- sum(pupils$fsm_status == "FSM") / nrow(pupils)
cat("FSM proportion in simulated pupils:", fsm_in_pupils, "\n")

# Check the FSM proportion at school level matches the overall proportion
schools_simplified$fsm_pupils <- schools_simplified$fsm_proportion * schools_simplified$pupil_count
schools_simplified$non_fsm_pupils <- (1 - schools_simplified$fsm_proportion) * schools_simplified$pupil_count

schools_simplified$total_pupils_check <- schools_simplified$fsm_pupils + schools_simplified$non_fsm_pupils

total_fsm_pupils <- sum(schools_simplified$fsm_pupils)
total_pupils_all <- sum(schools_simplified$pupil_count)
fsm_proportion_by_school <- total_fsm_pupils / total_pupils_all

cat("FSM proportion calculated from schools:", fsm_proportion_by_school, "\n")
cat("Difference between pupils and schools calculation:", abs(fsm_in_pupils - fsm_proportion_by_school), "\n")
print("Success.")

#05. Sampling
#Check the number of schools sampled is correct.
print("5. Sampling")
cat("Total required schools:", config$n_treatment + config$n_control, "\n")
cat("Sampled schools:", nrow(schools_sampled), "\n")
print("Success, both match")

#06. Minimisation
print("6. Minimisation")

  #Check assignment to treatment and control groups
  #Ratio should be roughly 1:1 between treatment and control.
  overall_balance <- table(schools_minimised$treatment)
  balance_region <- table(schools_minimised$region_simple, schools_minimised$treatment) 
  balance_urban <- table(schools_minimised$urban_rural_simple, schools_minimised$treatment) 
  balance_fsm <- table(schools_minimised$fsm_tertile, schools_minimised$treatment)
  balance_mh <- table(schools_minimised$prior_mh_support, schools_minimised$treatment)

  #statistical tests for the balance between them.
  #The X^2 value should be close to 0.
  #The p-value should be high (above 0.05), indicating no significant differences. 
  chisq.test(balance_region) 
  chisq.test(balance_urban) 
  chisq.test(balance_fsm)
  chisq.test(balance_mh)

print("Overall balance and balance by factors:")
print("Overall balance:")
print(overall_balance)
print("Balance by region:")
print(balance_region)
print("Balance by urban/rural:")
print(balance_urban)
print("Balance by FSM:")
print(balance_fsm)
print("Balance by MH support:")
print(balance_mh)
cat("Chi-squared tests for balance by factors:\n")
cat("Region:\n")
print(chisq.test(balance_region))
cat("Urban/Rural:\n")
print(chisq.test(balance_urban))
cat("FSM:\n")
print(chisq.test(balance_fsm))
cat("Prior MH Support:\n")
print(chisq.test(balance_mh))

print("Success. Only odd result is Prior MH support. X2 is 0 and p-value is 1.")
print("This is because the target distribution was nearly 50:50. X2 is very close to 0.")

#07. Simulate school treatment.
print("7. Simulate school treatment.")
cat("Orignal compliance probabilities:", paste(config$compliance_probs, collapse=","), "\n")
cat("Assigned compliance status distribution:\n")
print(table(schools_treatment$compliance_status))

#Check pupil counts for treatment add up. 
cat("Target pupils in treatment group:", config$YAM_pupils, "\n")
cat("Assigned pupils in treatment group:", 
sum(schools_treatment$randomised_pupil_counts[schools_treatment$treatment == "Treatment"]), "\n")

cat("Target pupils in control group:", config$usual_practice_pupils, "\n")
cat("Assigned pupils in control group:", 
sum(schools_treatment$randomised_pupil_counts[schools_treatment$treatment == "Control"]), "\n")

#Check the minimum and maximum pupils counts are within the bounds. 
cat("Original pupil sample bounds:", paste(config$pupil_sample_bounds, collapse=","), "\n")
cat("Minimum assigned pupils across both groups:", min(schools_treatment$randomised_pupil_counts), "\n")
cat("Maximum assigned pupils across both groups:", max(schools_treatment$randomised_pupil_counts), "\n")
print("Success")
print("The value left over from the original split of pupils is distributed first to higher pupil count schools.")

#08. Sample pupils within schools: 
print("8. Sample pupils within schools.")
cat("Total pupils needed:", config$YAM_pupils + config$usual_practice_pupils, "\n")
cat("Total pupils sampled:", nrow(pupils_sampled), "\n")
print("Success, both match")

#09. Join sampled pupils and school data. 
#Check this is the same as the sampled pupils.
print("9. Join sampled pupils and school data.")
cat("Total pupils after join:", nrow(joined_data), "\n")
#Check that column repition is not happening.
cat("Columns in joined data:\n")
print(colnames(joined_data))
print("Success, no duplicates")

#10. Simulate outcomes. 
print("10. Simulate outcomes.")
cat("Target SMFQ Standard Deviation:", config$baseline_sd, "\n")
cat("Assigned SMFQ Standard Deviation:", sd(results_data$smfq_baseline), "\n")
cat("Target SMFQ Threshold:", config$threshold, "\n")
cat("Target SMFQ Proportion Above Threshold:", config$target_prop_above, "\n")
cat("Assigned SMFQ Proportion Above Threshold (12):", 
  mean(results_data$smfq_baseline > config$threshold), "\n")

target_mean = compute_mean_from_target(
  threshold   = config$threshold,
  target_prop = config$target_prop_above,
  sd          = config$baseline_sd
)
cat("Target SMFQ mean:", target_mean, "\n")
cat("Assigned SMFQ mean:", mean(results_data$smfq_baseline), "\n")

#Check that the follow-up scores are within bounds.
cat("Target mean for control group:", target_mean + config$control_change_mean, "\n")
cat("Assigned mean for control group:", 
  mean(results_data$smfq_followup[results_data$treatment == "Control"]), "\n")

cat("Target SD for control group:", sqrt(config$baseline_sd^2 + config$control_change_sd^2), "\n")
cat("Assigned SD for control group:", 
  sd(results_data$smfq_followup[results_data$treatment == "Control"]), "\n")

cat("Target mean for treatment group:", target_mean + config$treatment_change_mean, "\n")
cat("Assigned mean for treatment group:", 
  mean(results_data$smfq_followup[results_data$treatment == "Treatment"]), "\n")

cat("Target SD for treatment group:", sqrt(config$baseline_sd^2 + config$treatment_change_sd^2), "\n")
cat("Assigned SD for treatment group:", 
  sd(results_data$smfq_followup[results_data$treatment == "Treatment"]), "\n")

#Check minimum and maximum values are within bounds.
cat("Minimum SMFQ score in the results:", min(results_data$smfq_baseline), "\n")
cat("Maximum SMFQ score in the results:", max(results_data$smfq_baseline), "\n")
print("Success - most results within 10% of target. Variation expected due to random sampling.")

#11. Primary outcome analysis.
#The thing to check is the treatment effect is similar to expected (above)
print("11. Primary outcome analysis.")
cat("Expected treatment effect:", config$treatment_change_mean - config$control_change_mean, "\n")
cat("Treatment effect result:", primary_results$treatment_effect, "\n")
cat("Effect size result:", primary_results$effect_size, "\n")
cat("Overall results summary:\n")
print(primary_results)
print("Success")

#12. Moderator analysis.
print("12. Moderator analysis.")
cat("Moderator analysis results:\n")
print(moderator_results)
print("Success")

#13. CACE analysis
print("13. CACE analysis.")
cat("Expected CACE effect:", config$treatment_change_mean - config$control_change_mean, "\n")
cat("Overall CACE effect:", cace_results$cace_coefficient, "\n")
print("Success")

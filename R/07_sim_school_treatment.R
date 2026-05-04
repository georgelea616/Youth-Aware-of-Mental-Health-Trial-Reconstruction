#At the moment, I'm not sure that the pupil counts are correctly distributed. 
#I think this is something we can figure out in testing.
# Removes duplicate schools and keeps relevant variables
prepare_school_data <- function(schools_trial) {
  dplyr::distinct(schools_trial, school_id, .keep_all = TRUE)
}

# Simulates compliance for treatment schools only
simulate_compliance <- function(schools, config) {
  schools$compliance_status <- ifelse(
    schools$treatment == "Treatment",
    sample(
      config$compliance_levels,
      size = nrow(schools),
      replace = TRUE,
      prob = config$compliance_probs
    ),
    NA
  )
  
  schools
}

# Allocates pupil counts across treatment and control schools
assign_pupil_counts <- function(schools, config) {
  schools$randomised_pupil_counts <- NA_integer_
  
  treatment_idx <- which(schools$treatment == "Treatment")
  control_idx <- which(schools$treatment == "Control")
  
  schools$randomised_pupil_counts[treatment_idx] <- randomise_pupil_counts(
    length(treatment_idx),
    config$YAM_pupils,
    config$pupil_sample_bounds
  )
  
  schools$randomised_pupil_counts[control_idx] <- randomise_pupil_counts(
    length(control_idx),
    config$usual_practice_pupils,
    config$pupil_sample_bounds
  )
  
  schools
}

# Randomises pupil counts across schools while respecting total and bounds
randomise_pupil_counts <- function(n, total_pupils, pupil_sample_bounds) {
  # Generate n random numbers within bounds
  random_vals <- runif(n, pupil_sample_bounds[1], pupil_sample_bounds[2])
  
  # Scale to sum to total_pupils
  randomised <- round((random_vals / sum(random_vals)) * total_pupils)
  
  # Adjust for rounding to match exact total
  diff <- total_pupils - sum(randomised)
  if (diff != 0) {
    randomised[which.max(randomised)] <- randomised[which.max(randomised)] + diff
  }
  
  randomised
}

# Selects only variables needed for downstream joins
select_school_variables <- function(schools) {
  dplyr::select(
    schools,
    pupil_count,
    randomised_pupil_counts,
    fsm_tertile,
    urban_rural_simple,
    region_simple,
    treatment,
    compliance_status,
    school_id,
    prior_mh_support
  )
}

# Wrapper function to execute all school treatment simulation functions
run_school_treatment <- function(schools_trial, config) {
  schools_trial <- prepare_school_data(schools_trial)
  schools_trial <- simulate_compliance(schools_trial, config)
  schools_trial <- assign_pupil_counts(schools_trial, config)
  schools_trial <- select_school_variables(schools_trial)
  return(schools_trial)

  #Sanity checks
  print ("Compliance probs:")
  print(config$compliance_probs)
  print ("Compliance allocations: ")
  print(table(schools$treatment))
  print("Needed randomised pupil counts: (Treatment, Control): ")
  print(config$YAM_pupils, config$usual_practice_pupils)
  print("Actual randomised pupil counts: (Treatment, Control): ")
  print(
    sum(schools$randomised_pupil_counts[schools$treatment == "Treatment"]),
    sum(schools$randomised_pupil_counts[schools$treatment == "Control"]))
}

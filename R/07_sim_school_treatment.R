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
  
  # First, clamp any values that exceed bounds from rounding
  # This maintains the core values while fixing violations
  violations <- randomised > pupil_sample_bounds[2]
  if (any(violations)) {
    # Clamp to upper bound and adjust the rounding difference
    randomised[violations] <- pupil_sample_bounds[2]
  }
  
  violations <- randomised < pupil_sample_bounds[1]
  if (any(violations)) {
    # Clamp to lower bound and adjust the rounding difference
    randomised[violations] <- pupil_sample_bounds[1]
  }
  
  # Now adjust for rounding to match exact total while respecting bounds
  diff <- total_pupils - sum(randomised)
  
  if (diff != 0) {
    # Get indices sorted by current count (descending)
    indices <- order(randomised, decreasing = TRUE)
    
    for (idx in indices) {
      if (diff == 0) break
      
      if (diff > 0) {
        # Need to increase this school's count (only if space available)
        space_available <- pupil_sample_bounds[2] - randomised[idx]
        if (space_available > 0) {
          increase <- min(diff, space_available)
          randomised[idx] <- randomised[idx] + increase
          diff <- diff - increase
        }
      } else if (diff < 0) {
        # Need to decrease this school's count (only if space available)
        space_available <- randomised[idx] - pupil_sample_bounds[1]
        if (space_available > 0) {
          decrease <- min(-diff, space_available)
          randomised[idx] <- randomised[idx] - decrease
          diff <- diff + decrease
        }
      }
    }
    
    # If diff is still non-zero, we have a constraint conflict
    # This shouldn't happen with valid input, but handle gracefully
    if (diff != 0) {
      warning("Could not distribute all pupils while respecting bounds. Remaining diff: ", diff)
    }
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
}

# Generic sampler for categorical pupil attributes
simulate_from_config <- function(n, levels, probs) {
  sample(levels, size = n, replace = TRUE, prob = probs)
}

# Factory to create simulation wrappers for each pupil attribute
make_simulator <- function(levels_name, probs_name) {
  function(n_pupils, config) {
    simulate_from_config(
      n_pupils,
      config[[levels_name]],
      config[[probs_name]]
    )
  }
}

# Simulates pupil gender values
simulate_pupil_genders <- make_simulator("gender_levels", "gender_probs")

# Simulates pupil ethnicity values
simulate_pupil_ethnicities <- make_simulator("ethnicity_levels", "ethnicity_probs")

# Simulates prior poor mental health status
simulate_previous_poor_mh <- make_simulator("previous_poor_mh_levels", "previous_poor_mh_probs")

# Simulates SEN status values
simulate_sen_status <- make_simulator("sen_levels", "sen_probs")

# Simulates FSM (Free School Meals) eligibility for pupils
simulate_pupil_fsm <- make_simulator("fsm_levels", "fsm_probs")

# Assigns each pupil to a school based on pupil counts
create_school_assignments <- function(schools) {
  rep(schools$school_id, times = schools$pupil_count)
}

# Combines all pupil attributes into a data frame
create_pupil_dataframe <- function(genders,
                                   ethnicities,
                                   previous_poor_mh,
                                   sen_status,
                                   fsm_status,
                                   school_assignments) {
  data.frame(
    gender = genders,
    ethnicity = ethnicities,
    previous_poor_mh = previous_poor_mh,
    sen_status = sen_status,
    fsm_status = fsm_status,
    school_id = school_assignments
  )
}

# Runs full simulation to generate pupil-level dataset
simulate_pupils <- function(schools, total_pupils, config) {
  set.seed(config$pupil_seed)

  n_pupils <- total_pupils
  school_assignments <- create_school_assignments(schools)

  create_pupil_dataframe(
    genders = simulate_pupil_genders(n_pupils, config),
    ethnicities = simulate_pupil_ethnicities(n_pupils, config),
    previous_poor_mh = simulate_previous_poor_mh(n_pupils, config),
    sen_status = simulate_sen_status(n_pupils, config),
    fsm_status = simulate_pupil_fsm(n_pupils, config),
    school_assignments = school_assignments
  )
}
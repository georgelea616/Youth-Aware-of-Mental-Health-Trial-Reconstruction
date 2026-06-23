# Simulates baseline scores for pupils
#N.B. Check the distribution of scores over 12. 

compute_mean_from_target <- function(threshold, target_prop, sd) {
  z <- qnorm(1 - target_prop)
  threshold - z * sd
}

simulate_baseline_scores <- function(n, config) {
  mu <- compute_mean_from_target(
    threshold   = config$threshold,
    target_prop = config$target_prop_above,
    sd          = config$baseline_sd
  )
  
  scores <- rnorm(n, mu, config$baseline_sd)
  
  pmin(
    pmax(round(scores), config$score_min),
    config$score_max
  )
}

# Simulates follow-up scores based on treatment assignment
simulate_followup_scores <- function(baseline, treatment, config) {
  n <- length(baseline)
  
  control_change   <- rnorm(n, config$control_change_mean, config$control_change_sd)
  treatment_change <- rnorm(n, config$treatment_change_mean, config$treatment_change_sd)
  
  change <- ifelse(treatment == "Treatment", treatment_change, control_change)
  
  pmin(
    pmax(round(baseline + change), config$score_min),
    config$score_max
  )
}

# Wrapper function to execute all outcome simulation functions
run_sim_outcome <- function(pupils, config) {
  pupils$smfq_baseline <- simulate_baseline_scores(nrow(pupils), config)
  pupils$smfq_followup <- simulate_followup_scores(pupils$smfq_baseline, pupils$treatment, config)
  pupils
}


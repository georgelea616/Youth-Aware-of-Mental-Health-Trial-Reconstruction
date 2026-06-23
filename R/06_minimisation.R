# ----------------------------------
# Initial allocation
# ----------------------------------

# Assigns first school using baseline probabilities
assign_first_school <- function(schools, config) {
  
  schools$treatment[1] <- sample(
    c("Treatment", "Control"),
    1,
    prob = c(0.5, 0.5)  # Explicit 1:1 baseline probability
  )
  
  schools
}
# ----------------------------------
# Core allocation helpers
# ----------------------------------

# Computes remaining treatment/control slots
get_remaining_counts <- function(schools, config) {
  list(
    treat = config$n_treatment - sum(schools$treatment == "Treatment", na.rm = TRUE),
    control = config$n_control - sum(schools$treatment == "Control", na.rm = TRUE)
  )
}

# Random allocation weighted by remaining slots
random_allocation <- function(remaining) {
  if (remaining$treat + remaining$control == 0) {
    stop("No remaining allocation slots")
  }
  
  sample(
    c("Treatment", "Control"),
    1,
    prob = c(0.5, 0.5)  # Equal probability when both arms have slots
  )
}


minimisation_allocation <- function(schools, i, remaining) {
  
  treat_temp <- schools
  treat_temp$treatment[i] <- "Treatment"
  imbalance_treat <- calculate_imbalance(treat_temp)
  
  control_temp <- schools
  control_temp$treatment[i] <- "Control"
  imbalance_control <- calculate_imbalance(control_temp)
  
  if (imbalance_treat < imbalance_control) {
    "Treatment"
  } else if (imbalance_control < imbalance_treat) {
    "Control"
  } else {
    random_allocation(remaining)
  }
}

# Assigns groups with 10% randomisation
assign_treatment <- function(schools, i, config) {
  remaining <- get_remaining_counts(schools, config)
  
  if (remaining$treat == 0) return("Control")
  if (remaining$control == 0) return("Treatment")
  
  # 10% simple randomisation
  if (runif(1) < 0.1) {
    return(random_allocation(remaining))
  }
  
  # 90% minimisation
  minimisation_allocation(schools, i, remaining)
}

#This will actually calculate the imablances
calculate_imbalance <- function(schools, 
                                factors = c("prior_mh_support", "fsm_tertile", "region_simple", "urban_rural_simple"),
                                weights = NULL) {
  
  # Default: equal weights
  if (is.null(weights)) {
    weights <- rep(1, length(factors))
    names(weights) <- factors
  }
  
  total_imbalance <- 0
  
  for (f in factors) {
    
    # Drop rows with missing factor values OR missing treatment
    df <- schools[!is.na(schools[[f]]) & !is.na(schools$treatment), ]
    
    if (nrow(df) == 0) next
    
    # Contingency table: factor level x treatment arm.
    # Explicit levels keep both arms present early in allocation.
    treatment_arm <- factor(df$treatment, levels = c("Treatment", "Control"))
    tab <- table(df[[f]], treatment_arm)
    
    # Compute marginal imbalance for this factor:
    # sum over levels of |n_treat - n_control|
    imbalance_f <- sum(abs(tab[, "Treatment"] - tab[, "Control"]))
    
    # Add weighted contribution
    total_imbalance <- total_imbalance + weights[f] * imbalance_f
  }
  
  return(total_imbalance)
}

# Runs allocation loop across all schools
run_allocation <- function(schools, config) {
  for (i in 2:nrow(schools)) {
    schools$treatment[i] <- assign_treatment(schools, i, config)
  }
  
  schools
}

# ----------------------------------
# Main function (allocation only)
# ----------------------------------

# Runs minimisation-based allocation (expects pre-sampled schools)
minimise_schools <- function(schools_trial, config) {
  
  schools_trial <- schools_trial |>
    assign_first_school(config) |>
    run_allocation(config)
  
  return(schools_trial) 
} 

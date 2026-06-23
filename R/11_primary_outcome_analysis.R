
primary_outcome <- function(pupils_joined) {
  # Ensure variables are factors
  pupils_joined <- pupils_joined %>%
    mutate(
      treatment = factor(treatment),
      school_id = factor(school_id),
      region_simple = factor(region_simple),
      urban_rural_simple = factor(urban_rural_simple),
      prior_mh_support = factor(prior_mh_support),
      fsm_tertile = factor(fsm_tertile),
      previous_poor_mh = factor(previous_poor_mh)
    )
  
  # Fit mixed model
  primary_model <- lmer(
    smfq_followup ~ 
      treatment +
      smfq_baseline +
      region_simple +
      urban_rural_simple +
      prior_mh_support +
      fsm_tertile +
      previous_poor_mh +
      (1 | school_id),
    data = pupils_joined
  )
  
  # Model summary
  model_summary <- summary(primary_model)
  
  # Confidence intervals
  ci <- confint(primary_model, method = "Wald")
  
  # Treatment effect
  treatment_effect <- fixef(primary_model)["treatmentTreatment"]
  
  # Effect size (standardised)
  sd_baseline <- sd(pupils_joined$smfq_baseline, na.rm = TRUE)
  effect_size <- treatment_effect / sd_baseline
  
  # ICC calculation
  variance_components <- as.data.frame(VarCorr(primary_model))
  
  school_var <- variance_components$vcov[1]
  resid_var  <- variance_components$vcov[2]
  
  icc <- school_var / (school_var + resid_var)
  
  # Return structured results
  results <- list(
    model = primary_model,
    summary = model_summary,
    confidence_intervals = ci,
    treatment_effect = treatment_effect,
    effect_size = effect_size,
    ICC = icc
  )
  
  return(results)
  return(pupils_joined)
}



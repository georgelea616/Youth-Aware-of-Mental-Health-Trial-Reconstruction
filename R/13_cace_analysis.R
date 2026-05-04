run_cace_analysis <- function(pupils_joined, config) {
  
  # --------------------------------------------------
  # 1. Prepare variables & Refined Compliance
  # --------------------------------------------------
  # We define compliance strictly:
  # 1. Must be in the treatment group.
  # 2. School must be randomised as a complier.
  # 3. Control group is ALWAYS 0 (No-shows/One-sided compliance).
  
  pupils_joined <- pupils_joined %>%
    mutate(
      treatment_numeric = ifelse(treatment == "Treatment", 1, 0),
      complier = ifelse(
        treatment == "Treatment" & compliance_status == "Complier",
        1, 
        0
      ),
      # Ensure factors are set for covariates
      fsm_tertile = factor(fsm_tertile),
      region_simple = factor(region_simple),
      urban_rural_simple = factor(urban_rural_simple)
    )
  
  # --------------------------------------------------
  # 2. Instrumental Variable (CACE) model
  # --------------------------------------------------
  # We use feols with the syntax: outcome ~ exogenous_vars | endogenous_var ~ instrument
  # We cluster by school_id to match your primary mixed model logic.
  
  cace_model <- feols(
    smfq_followup ~ 
      gender +
      smfq_baseline + 
      region_simple + 
      urban_rural_simple + 
      prior_mh_support + 
      fsm_tertile + 
      previous_poor_mh | 
      complier ~ treatment_numeric, 
    data = pupils_joined,
    cluster = ~ school_id
  )
  
  # --------------------------------------------------
  # 3. Extract treatment effect & Standardize
  # --------------------------------------------------
  
  # Extract the coefficient for the instrumented 'complier' variable
  cace_effect <- coef(cace_model)["fit_complier"]
  
  # Calculate Standardized Effect Size (using baseline SD of the whole sample)
  sd_baseline <- sd(pupils_joined$smfq_baseline, na.rm = TRUE)
  effect_size_std <- cace_effect / sd_baseline
  
  # Get Confidence Intervals (Clustered)
  ci <- confint(cace_model)["fit_complier", ]
  
  # --------------------------------------------------
  # 4. Return results
  # --------------------------------------------------
  
  results <- list(
    model_summary = summary(cace_model),
    cace_coefficient = cace_effect,
    ci_low = ci[1],
    ci_high = ci[2],
    std_effect_size = effect_size_std,
    first_stage_f = fitstat(cace_model, "ivf") # Check if instrument is strong
  )
  
  return(results)
}

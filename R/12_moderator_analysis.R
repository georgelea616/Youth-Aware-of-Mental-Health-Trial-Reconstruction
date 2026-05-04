run_moderator_analysis <- function(pupils_joined, config) {
  
  run_single_model <- function(mod_var) {
    
    tryCatch({
      
      formula_text <- paste0(
        "smfq_followup ~ treatment * ", mod_var, " + ",
        "smfq_baseline + ",
        "region_simple + ",
        "urban_rural_simple + ",
        "prior_mh_support + ",
        "fsm_tertile + ",
        "(1 | school_id)"
      )
      
      model <- lmer(as.formula(formula_text), data = pupils_joined)
      
      # Treatment effect
      treatment_est <- fixef(model)["treatmentTreatment"]
      
      # Confidence interval
      ci <- confint(model, parm = "treatmentTreatment", method = "Wald")
      
      # Effect size
      outcome_sd <- sd(pupils_joined$smfq_followup, na.rm = TRUE)
      effect_size <- treatment_est / outcome_sd
      
      # Robust ICC calculation
      variance_components <- as.data.frame(VarCorr(model))
      
      school_var <- variance_components$vcov[1]
      resid_var  <- variance_components$vcov[2]
      
      icc_val <- school_var / (school_var + resid_var)
      
      data.frame(
        moderator = mod_var,
        treatment_effect = treatment_est,
        CI_lower = ci[1],
        CI_upper = ci[2],
        effect_size = effect_size,
        ICC = icc_val,
        model_status = "success"
      )
      
    }, error = function(e) {
      
      data.frame(
        moderator = mod_var,
        treatment_effect = NA,
        CI_lower = NA,
        CI_upper = NA,
        effect_size = NA,
        ICC = NA,
        model_status = "failed"
      )
      
    })
    
  }
  
  moderator_results <- bind_rows(
    lapply(config$moderators, run_single_model)
  )
  
  return(moderator_results)
}

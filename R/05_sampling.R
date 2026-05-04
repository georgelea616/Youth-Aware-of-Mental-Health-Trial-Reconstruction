# Randomly selects required number of schools and initialises treatment column
sample_schools <- function(schools, config) {
  set.seed(config$randomisation_seed)
  
  total_required <- config$n_treatment + config$n_control
  
  sampled <- schools[sample(nrow(schools), total_required), ]
  sampled$treatment <- NA_character_
  
  sampled
}
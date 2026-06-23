# Joins sampled pupils with school-level data. A lot of validation goes on in this step.
# Note: randomised_pupil_counts is already in pupils from sample_pupils_within_schools, 
# so we exclude it from schools to avoid duplication
join_pupil_school_data <- function(pupils, schools) {
  schools_to_join <- dplyr::select(schools, -randomised_pupil_counts)
  dplyr::inner_join(pupils, schools_to_join, by = "school_id")
}
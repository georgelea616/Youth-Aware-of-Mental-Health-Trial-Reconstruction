# Joins sampled pupils with school-level data. A lot of validation goes on in this step. 
join_pupil_school_data <- function(pupils, schools) {
  dplyr::inner_join(pupils, schools, by = "school_id")
}
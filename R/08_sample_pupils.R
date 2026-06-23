
sample_pupils_within_schools <- function(pupils, schools) {
  pupils_sampled <- pupils |>
    dplyr::inner_join(
      dplyr::select(schools, school_id, randomised_pupil_counts),
      by = "school_id"
    ) |>
    dplyr::group_by(school_id) |>
    dplyr::group_modify(\(.x, .y) {
      n_to_sample <- dplyr::first(.x$randomised_pupil_counts)
      dplyr::slice_sample(.x, n = min(n_to_sample, nrow(.x)))
    }) |>
    dplyr::ungroup()

    return(pupils_sampled)
}


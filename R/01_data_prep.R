read_schools_data <- function(filepath) {
  # This reads in the raw schools data.
  if (!file.exists(filepath)) {
    stop("File does not exist: ", filepath)
  }
  read.csv(filepath)
}

filter_school_base <- function(data) {
  # This keeps only the rows used in the simulation.
  data %>%
    filter(
      time_period == "202425",
      time_identifier == "Academic year",
      geographic_level == "Local authority",
      phase_type_grouping == "State-funded secondary"
    )
}

get_breakdown_columns <- function() {
  # These are the columns used to define totals and breakdowns.
  # phase_type_grouping is excluded as it's now a fixed filter for State-funded secondary
  c(
    "sex_of_school_description",
    "type_of_establishment",
    "denomination",
    "admissions_policy",
    "urban_rural",
    "academy_flag"
  )
}

filter_total_rows <- function(data, breakdown_columns) {
  # This keeps only rows where every breakdown column is "Total".
  data %>%
    filter(if_all(all_of(breakdown_columns), ~ .x == "Total"))
}

filter_breakdown_rows <- function(data, breakdown_var, breakdown_columns) {
  # This keeps one breakdown variable and holds the rest at "Total".
  other_breakdown_columns <- setdiff(breakdown_columns, breakdown_var)

  data %>%
    filter(
      .data[[breakdown_var]] != "Total",
      if_all(all_of(other_breakdown_columns), ~ .x == "Total")
    )
}

summarise_regional_totals <- function(data) {
  # This produces school, pupil, and FSM totals for each region.
  data %>%
    group_by(region_name) %>%
    summarise(
      total_schools = sum(number_of_schools, na.rm = TRUE),
      total_pupils = sum(headcount_of_pupils, na.rm = TRUE),
      total_fsm = sum(number_of_pupils_known_to_be_eligible_for_free_school_meals, na.rm = TRUE),
      .groups = "drop"
    )
}

summarise_school_counts <- function(data, breakdown_var) {
  # This produces school totals for one breakdown variable.
  data %>%
    group_by(.data[[breakdown_var]]) %>%
    summarise(
      total_schools = sum(number_of_schools, na.rm = TRUE),
      .groups = "drop"
    )
}

summarise_pupil_fsm_totals <- function(data) {
  # This sums pupils and FSM counts independently of the school breakdowns.
  data %>%
    summarise(
      total_pupils = sum(headcount_of_pupils, na.rm = TRUE),
      total_fsm = sum(number_of_pupils_known_to_be_eligible_for_free_school_meals, na.rm = TRUE)
    )
}

calculate_fsm_percentage <- function(pupil_fsm_totals) {
  # This calculates the percentage of pupils eligible for FSM.
  pupil_fsm_totals$total_fsm / pupil_fsm_totals$total_pupils
}

prepare_data <- function(filepath) {
  # Read the raw schools data and keep the rows used in the simulation.
  # Return regional totals, urban-rural school counts, and the overall FSM share.
  if ((!file.exists(filepath) || file.info(filepath)$size == 0) &&
      exists("download_schools_data", mode = "function")) {
    filepath <- download_schools_data(filepath)
  }

  schools_raw <- read_schools_data(filepath)
  schools_base <- filter_school_base(schools_raw)
  breakdown_columns <- get_breakdown_columns()

  total_rows <- filter_total_rows(schools_base, breakdown_columns)

  regional_totals <- summarise_regional_totals(total_rows)

  pupil_fsm_totals <- summarise_pupil_fsm_totals(total_rows)
  fsm_percentage <- calculate_fsm_percentage(pupil_fsm_totals)

  urban_rural_school_counts <- schools_base %>%
    filter_breakdown_rows("urban_rural", breakdown_columns) %>%
    summarise_school_counts("urban_rural")

  total_schools <- sum(urban_rural_school_counts$total_schools)
  total_pupils <- sum(regional_totals$total_pupils)

  list(
    regional_totals = regional_totals,
    urban_rural_school_counts = urban_rural_school_counts,
    fsm_percentage = fsm_percentage,
    total_schools = total_schools,
    total_pupils = total_pupils
  )
}

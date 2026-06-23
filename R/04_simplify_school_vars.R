
# Converts selected school columns to factors. This is a necessary step before transformation. 
factorise_school_variables <- function(schools) {
  schools$prior_mh_support <- factor(schools$prior_mh_support)
  schools$region <- factor(schools$region)
  schools$urban_rural <- factor(schools$urban_rural)
  schools
}

# Calculates FSM percentage from pupils data and attaches to school_id
calculate_fsm_percentage_from_pupils <- function(schools, pupils) {
  fsm_by_school <- pupils %>%
    dplyr::group_by(school_id) %>%
    dplyr::summarise(fsm_proportion = mean(fsm_status == "FSM"), .groups = "drop")
  
  schools <- schools %>%
    dplyr::left_join(fsm_by_school, by = "school_id")
  
  schools
}

# Creates FSM tertile groups based on school FSM proportion.
create_fsm_tertile <- function(schools) {
  fsm_rank <- rank(schools$fsm_proportion, ties.method = "random")

  schools$fsm_tertile <- cut(
    fsm_rank,
    breaks = quantile(fsm_rank, probs = seq(0, 1, 1/3)),
    include.lowest = TRUE,
    labels = c("Low", "Medium", "High")
  )

  schools
}

# Simplifies urban/rural classification into Urban, Rural, or NA
create_urban_rural_simple <- function(schools) {
  schools$urban_rural_simple <- ifelse(
    grepl("Urban", schools$urban_rural, ignore.case = TRUE),
    "Urban",
    ifelse(
      grepl("Rural", schools$urban_rural, ignore.case = TRUE),
      "Rural",
      NA_character_
    )
  )

  schools
}

# Removes rows where simplified urban/rural classification is missing
filter_unknown_urban_rural <- function(schools) {
  schools[!is.na(schools$urban_rural_simple), ]
}

# Groups regions into North, Midlands, and South categories
create_region_simple <- function(schools) {
  schools$region_simple <- dplyr::case_when(
    schools$region %in% c("North East", "North West", "Yorkshire and The Humber") ~ "North",
    schools$region %in% c("East Midlands", "West Midlands") ~ "Midlands",
    schools$region %in% c("East of England", "London", "South East", "South West") ~ "South",
    TRUE ~ NA_character_
  )
  
  schools$region_simple <- factor(
    schools$region_simple,
    levels = c("North", "Midlands", "South")
  )

  schools
}

# Runs all variable transformations to create simplified variables 
simplify_vars <- function(schools, pupils) {
  schools <- calculate_fsm_percentage_from_pupils(schools, pupils)
  
  schools |>
    factorise_school_variables() |>
    create_fsm_tertile() |>
    create_urban_rural_simple() |> 
    create_region_simple()|>
    filter_unknown_urban_rural()
}

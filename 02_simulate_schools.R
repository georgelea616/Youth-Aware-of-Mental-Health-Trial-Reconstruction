create_school_ids <- function(n_schools) {
  # This creates the starting school table with one row per school.
  data.frame(school_id = seq_len(n_schools))
}

calculate_region_probabilities <- function(regional_totals) {
  # This turns the regional school totals into sampling probabilities.
  regional_totals$total_schools / sum(regional_totals$total_schools)
}

simulate_regions <- function(regional_totals, n_schools) {
  # This simulates one region for each school.
  sample(
    regional_totals$region_name,
    size = n_schools,
    replace = TRUE,
    prob = calculate_region_probabilities(regional_totals)
  )
}

calculate_urban_rural_probabilities <- function(urban_rural_school_counts) {
  # This turns the urban-rural school totals into sampling probabilities.
  urban_rural_school_counts$total_schools / sum(urban_rural_school_counts$total_schools)
}

simulate_urban_rural <- function(urban_rural_school_counts, n_schools) {
  # This simulates one urban-rural value for each school.
  sample(
    urban_rural_school_counts$urban_rural,
    size = n_schools,
    replace = TRUE,
    prob = calculate_urban_rural_probabilities(urban_rural_school_counts)
  )
}

simulate_prior_mh_support <- function(n_schools, prior_mh_support_prob) {
  # This simulates whether each school had prior mental health support.
  rbinom(n_schools, 1, prior_mh_support_prob)
}

#Distributes (on average) same number of pupils each school.
allocate_pupil_counts <- function(n_schools, total_pupils) {
  # This splits the total pupil count across the simulated schools.
  as.vector(
    rmultinom(
      1,
      size = total_pupils,
      prob = rep(1 / n_schools, n_schools)
    )
  )
}

simulate_schools <- function(regional_totals,
                             urban_rural_school_counts,
                             total_schools,
                             total_pupils,
                             config) {
  # This simulates schools using the region, urban-rural, and pupil totals.
  set.seed(config$school_seed)

  n_schools <- total_schools

  schools <- create_school_ids(n_schools)

  schools$region <- simulate_regions(regional_totals, n_schools)
  schools$urban_rural <- simulate_urban_rural(urban_rural_school_counts, n_schools)
  schools$prior_mh_support <- simulate_prior_mh_support(
    n_schools,
    config$prior_mh_support_prob
  )
  schools$pupil_count <- allocate_pupil_counts(n_schools, total_pupils)

  schools
}

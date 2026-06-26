SCHOOLS_DATA_URL <- "https://explore-education-statistics.service.gov.uk/data-catalogue/data-set/9556adc9-c5f3-4b9c-af2e-01e2a5e5901e/csv"

default_schools_data_path <- function() {
  here::here("data-raw", "schools_raw.csv")
}

schools_data_exists <- function(filepath = default_schools_data_path()) {
  file.exists(filepath) && file.info(filepath)$size > 0
}

download_schools_data <- function(
  filepath = default_schools_data_path(),
  url = SCHOOLS_DATA_URL,
  overwrite = FALSE
) {
  if (!overwrite && schools_data_exists(filepath)) {
    message("Using existing schools data: ", filepath)
    return(filepath)
  }

  dir.create(dirname(filepath), recursive = TRUE, showWarnings = FALSE)

  message("Downloading schools data to: ", filepath)
  download_status <- utils::download.file(
    url = url,
    destfile = filepath,
    mode = "wb",
    quiet = FALSE
  )

  if (!identical(download_status, 0L) || !schools_data_exists(filepath)) {
    stop("Data download failed. Expected file was not created: ", filepath)
  }

  filepath
}

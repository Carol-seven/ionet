#' Get data from the World Input-Output Database (WIOD)
#'
#' Download the data from \href{https://github.com/Carol-seven/ionet_ext}{ionet_ext},
#' an extension repository for storing data in the R package ionet,
#' and store it in the package directory.
#' If the data has already been downloaded, a message will be displayed.
#'
#' @importFrom utils download.file
#' @param version is the specific release of WIOD, either "2013 Release" or "2016 Release".
#' @param year is the specific year of the data.
#' @source \href{https://www.rug.nl/ggdc/valuechain/wiod/}{World Input-Output Database}
#' @note The size of the data may exceed the capacity of the internet connection,
#' potentially limiting the download speed.
#' @return NULL
#' @export

data_WIOD <- function(version = "2016 Release", year) {
  url <- "https://github.com/Carol-seven/ionet_ext/raw/master/"
  if (version == "2013 Release") {
    data_name <- paste0("WIOD2013_WIOT_", year, ".rda")
    url <- paste0(url, "WIOD%202013%20Release/", data_name)
  } else {
    data_name <- paste0("WIOD2016_WIOT_", year, ".rda")
    url <- paste0(url, "WIOD%202016%20Release/", data_name)
  }

  data_path <- file.path(system.file("data", package = "ionet"), data_name)

  if (file.exists(data_path)) {
    message("The data has already been downloaded!")
  } else {
    message("Downloading data...")
    download.file(url, destfile = data_path, mode = "wb")
  }

  invisible(NULL)
}

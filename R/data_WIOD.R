#' Get data from the World Input-Output Database (WIOD)
#'
#' Download the WIOD data from \href{https://github.com/Carol-seven/ionet_ext}{ionet_ext},
#' (an extension repository for storing data in the R package ionet),
#' store it in the package directory, and load it into the R workspace.
#' If the data has already been downloaded, a message will be displayed.
#' If the data is downloaded but incomplete, an error message will be displayed.
#'
#' @importFrom utils download.file
#' @param version The specific release of WIOD, either "2013 Release" or "2016 Release".
#' @param year The specific year of the data.
#' @source \href{https://www.rug.nl/ggdc/valuechain/wiod/}{World Input-Output Database}
#' @note The size of the data may exceed the capacity of the internet connection,
#' potentially limiting the download speed.
#' @return NULL
#' @export

data_WIOD <- function(version = "2016 Release",year) {

  url <- "https://github.com/Carol-seven/ionet_ext/raw/master/"

  if (version == "2013 Release") {
    data_name <- paste0("WIOD2013_WIOT_", year, ".rda")
    url <- paste0(url, "WIOD%202013%20Release/", data_name)
    data_size <- 15e+6
  } else if (version == "2016 Release") {
    data_name <- paste0("WIOD2016_WIOT_", year, ".rda")
    url <- paste0(url, "WIOD%202016%20Release/", data_name)
    data_size <- 43e+6
  } else {
    stop("Invalid release specified. Must be '2013 Release' or '2016 Release'!")
  }

  data_path <- file.path(system.file("data", package = "ionet"), data_name)

  if (!file.exists(data_path) | file.size(data_name) < data_size) {
    download.file(url, destfile = data_name, mode = "wb", quiet = TRUE)
    message("Downloading data...")
  }

  load(data_path)
  message("The data has already been downloaded and loaded!")

  invisible(NULL)
}

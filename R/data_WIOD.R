#' Get data from the World Input-Output Database (WIOD)
#'
#' Download the WIOD data from \href{https://github.com/Carol-seven/ionet_ext}{ionet_ext},
#' (an extension repository for storing data in the R package ionet),
#' store it in the package directory, and load it into the R workspace.
#' If the data has already been downloaded, a message will be displayed.
#' If the data is downloaded but incomplete, an error message will be displayed.
#'
#' @importFrom utils download.file
#' @param version The specific version of WIOD, either "2013 release", "2016 release", or "long run".
#' @param year The specific year of the data.
#' @source \href{https://www.rug.nl/ggdc/valuechain/wiod/}{World Input-Output Database}
#' @references
#' \itemize{
#' \item Dietzenbacher, E., Los, B., Stehrer R., Timmer, M. P. and de Vries, G. J. (2013).
#' "The Construction of World Input-Output Tables in the WIOD Project".
#' \emph{Economic Systems Research}, 25(1), 71--98.
#' \item Timmer, M. P., Dietzenbacher, E., Los, B., Stehrer, R. and de Vries, G. J. (2015).
#' "An Illustrated User Guide to the World Input-Output Database: the Case of Global Automotive Production".
#' \emph{Review of International Economics}, 23(3), 575--605.
#' \item Timmer, M. P., Los, B., Stehrer, R. and de Vries, G. J. (2016).
#' "An Anatomy of the Global Trade Slowdown based on the WIOD 2016 Release".
#' \emph{GGDC Research Memorandum 162, University of Groningen}.
#' \item Woltjer, P., Gouma, R. and Timmer, M. P. (2021).
#' "Long-run World Input-Output Database: Version 1.1 Sources and Methods".
#' \emph{GGDC Research Memorandum 190, University of Groningen}.
#' }
#' @note
#' \itemize{
#' \item The size of the data may exceed the capacity of the internet connection,
#' potentially limiting the download speed.
#' \item World input-output tables of the WIOD 2013 Release for the period from 1995 to 2011,
#' covering 41 economies (27 EU economies, 13 other major economies, and the Rest of the World),
#' each with 35 sectors.
#' The format of the table is a data frame with 1443 rows and 1646 columns.
#' Data are calculated in current prices.
#' Values are denoted in millions of US dollars (USD).
#' \item World input-output tables of the WIOD 2016 Release for the period from 2000 to 2014,
#' covering 44 economies (28 EU economies, 15 other major economies, and the Rest of the World),
#' each with 56 sectors.
#' The format of the table is a data frame with 2472 rows and 2690 columns.
#' Data are calculated in current prices.
#' Values are denoted in millions of US dollars (USD).
#' \item World input-output tables of the Long-run WIOD for the period from 1965 to 2000,
#' covering 26 economies (25 economies, and the Rest of the World), each with 23 sectors.
#' The format of the table is a data frame with 606 rows and 710 columns.
#' Data are calculated in current prices.
#' Values are denoted in millions of US dollars (USD).
#' }
#' @return The world input-output table of the WIOD specific version for the specific year.
#' @export

data_WIOD <- function(version = c("2013 release", "2016 release", "long run"),
                      year)
{
  url <- "https://github.com/Carol-seven/ionet_ext/raw/master/"

  if (!version %in% c("2013 release", "2016 release", "long run")) {
    stop("Invalid version specified. Must be '2013 release', '2016 release' or 'long run'!")
  }
  if (version == "2013 release") {
    if (year %in% c(1995L:2011L)) {
      data_name <- paste0("WIOD2013_WIOT_", year, ".rda")
      url <- paste0(url, "WIOD%202013%20Release/", data_name)
      data_size <- 15e+6
    } else {
      stop("Invalid year specified. Must be between 1995 and 2011.")
    }
  } else if (version == "2016 release") {
    if (year %in% c(2000L:2014L)) {
      data_name <- paste0("WIOD2016_WIOT_", year, ".rda")
      url <- paste0(url, "WIOD%202016%20Release/", data_name)
      data_size <- 43e+6
    } else {
      stop("Invalid year specified. Must be between 2000 and 2014.")
    }
  } else if (version == "long run") {
    if (year %in% c(1965L:2000L)) {
      data_name <- paste0("WIODlr_WIOT_", year, ".rda")
      url <- paste0(url, "WIOD%20long-run/", data_name)
      data_size <- 28e+5
    } else {
      stop("Invalid year specified. Must be between 1965 and 2000.")
    }
  }

  data_path <- file.path(system.file("data", package = "ionet"), data_name)

  if (!file.exists(data_path) | file.size(data_path) < data_size) {
    download.file(url, destfile = data_path, mode = "wb", quiet = TRUE)
    message("Downloading data...")
  }

  if (file.exists(data_path) & file.size(data_path) > data_size) {
    load(data_path, envir = globalenv())
    message("The data has already been downloaded and loaded!")
  }

  invisible(NULL)
}

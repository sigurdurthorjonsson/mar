
#' Connect to MFRI database
#'
#' A shortcut method
#'
#' @return A connection to the Oracle database
#' @export

connect_mar <- function() {
  DBI::dbConnect(DBI::dbDriver("Oracle"))
}

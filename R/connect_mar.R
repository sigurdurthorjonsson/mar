
#' Connect to MFRI database
#'
#' A shortcut method
#'
#' @param ... Additional arguements to pass to DBI functions
#'
#' @return A connection to the Oracle database
#' @export

connect_mar <- function(...) {
  DBI::dbConnect(DBI::dbDriver("Oracle"), ...)
}

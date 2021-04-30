
#' Connect to MFRI database
#'
#' A shortcut method, borrowing from gitlab.hafogvatn.is/dev/mar
#'
#' @param dbname Name of DB to connect to
#' @param ... Additional arguements to pass to DBI functions
#'
#' @return A connection to the Oracle database
#' @export

connect_mar <- function(dbname='sjor', ...) {
  ROracle::dbConnect(DBI::dbDriver("Oracle"), dbname=dbname, ...)
}

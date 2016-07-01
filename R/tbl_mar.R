#' Connection to mar
#'
#' @param mar tenging við oraclegrunn
#' @param tbl nafn oracle töflu
#'
#' @return fyrirspurn
#' @export
#'

tbl_mar <- function(mar, tbl) {
  d <- dplyr::tbl(mar,dplyr::sql(tbl)) %>%
    dplyr::rename_(.dots=stats::setNames(colnames(.),tolower(colnames(.))))
  return(d)
}

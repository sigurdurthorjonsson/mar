#' Connection to mar
#'
#' @param mar tenging við oraclegrunn
#' @param tbl nafn oracle töflu
#'
#' @return fyrirspurn
#' @export
#'

tbl_mar <- function(mar, tbl) {
  x <- strsplit(tbl,'\\.') %>% unlist()
  dplyr::tbl(mar,dbplyr::in_schema(x[1],x[2])) %>%
    dplyr::select_all(tolower)
}

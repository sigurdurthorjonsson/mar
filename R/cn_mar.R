#' Conform to mar column heading
#'
#' The function converts column of a dataframe, returning "_"
#' where there is a ".".
#'
#' @param con Tenging við Oracle
#'
#' @return SQL fyrirspurn
#'
#' @name cn_mar
#'
#' @export
#'
cn_mar <- function(con) {

  con %>% dplyr::select_all(function(x) gsub('.','_',x))

  }

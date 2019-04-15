#' Conform to fjolst column heading
#'
#' The function converts column of a dataframe, returning "."
#' where there is an "_".
#'
#' @name cn_fjolst
#'
#' @param con Tenging við Oracle
#'
#' @return SQL fyrirspurn
#'
#' @export
#'
cn_fjolst <- function(con) {

  con %>% dplyr::select_all(function(x) gsub('_','.',x))

  }

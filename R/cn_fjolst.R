#' Conform to fjolst column heading
#'
#' The function converts column of a dataframe, returning "."
#' where there is an "_".
#'
#' @param d
#'
#' @return dataframe
#' @export
#'
cn_fjolst <- function(d) {

  d %>% select_all(function(x) gsub('_','.',x))

  }

#' Conform to mar column heading
#'
#' The function converts column of a dataframe, returning "_"
#' where there is a ".".
#'
#' @param d
#'
#' @return dataframe
#' @export
#'
cn_mar <- function(d) {

  d %>% select_all(function(x) gsub('.','_',x))

  }

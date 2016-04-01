#' @title stofn
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
afli_stofn <- function(mar) {
  d <- dplyr::tbl(mar,dplyr::sql("afli.stofn")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))
  return(d)
}

#' @title afli
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
afli_afli <- function(mar) {
  d <- dplyr::tbl(mar,dplyr::sql("afli.afli")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))
  return(d)
}

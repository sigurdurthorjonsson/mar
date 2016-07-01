#' lesa veiðarfæri
#'
#' @param mar db connection
#'
#' @return db query object
#' @export
#'
lesa_veidarfaeri <- function(mar) {

  tbl_mar(mar, "orri.veidarfaeri") %>%
    dplyr::select(-c(snt:sbn))

}

#' lesa tegundir
#'
#' @param mar db connection
#'
#' @return db query object
#' @export
#'

lesa_tegundir <- function(mar){
  tbl_mar(mar, "orri.fisktegundir") %>%
    dplyr::select(-c(snt:sbn))
}

#' lesa synaflokka
#'
#' @param mar db connection
#'
#' @return db query object
#' @export
#'

lesa_synaflokka <- function(mar){
  tbl_mar(mar, "fiskar.synaflokkar")
}


#' londundarhofn
#'
#' @param mar db connection
#'
#' @return db query object
#' @export
#'
kvoti_stadur <- function(mar) {

  tbl_mar(mar, "kvoti.stadur")

}


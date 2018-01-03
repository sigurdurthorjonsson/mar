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

lesa_synaflokkar <- function(mar){
  tbl_mar(mar, "fiskar.synaflokkar")
}


#' londundarhofn
#'
#' @param mar db connection
#'
#' @return db query object
#'
kvoti_stadur <- function(mar) {

  tbl_mar(mar, "kvoti.stadur")

}

#' Orðabók
#'
#' Flettir upp í sjávardýraorðbókinni á Hafró vefnum
#' @param mar
#'
#' @return db query object
#' @export
ordabok <- function(mar){
  tbl_mar(mar, "orri.ordabok") %>%
    dplyr::left_join(tbl_mar(mar, "orri.ordabok_mal")) %>%
    dplyr::select(tegund = nafn,erlent_heiti = heiti,tungumal=nafn_mals,skammst)
}

#' lesa veiðarfæri
#'
#' @param mar db connection
#'
#' @name lesa_veidarfaeri
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
#' @name lesa_tegundir
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
#' @name lesa_synaflokkar
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
#' @name kvoti_stadur
#'
#' @return db query object
#'
kvoti_stadur <- function(mar) {

  tbl_mar(mar, "kvoti.stadur")

}

#' Orðabók
#'
#' Flettir upp í sjávardýraorðbókinni á Hafró vefnum
#'
#' @name ordabok
#'
#' @param mar connection to Oracle
#'
#' @return db query object
#' @export
ordabok <- function(mar){
  tbl_mar(mar, "orri.ordabok") %>%
    dplyr::left_join(tbl_mar(mar, "orri.ordabok_mal")) %>%
    dplyr::select(tegund = nafn,erlent_heiti = heiti,tungumal=nafn_mals,skammst)
}


#' @title Skipasaga
#'
#' @description XXX
#'
#' @name lods_skipasaga
#'
#' @param mar src_oracle tenging við oracle
#' @export
lods_skipasaga <- function(mar) {

  d <- tbl_mar(mar, "kvoti.skipasaga") %>%
    dplyr::select(-(snt:sbn))

  return(d)

}

#' @title Skipaskra
#'
#' @description XXX
#'
#' @name lesa_skipaskra
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
# #' @example
# #' mar <- dplyrOracle::src_oracle("mar")
# #' mar:::lods_skipasaga(mar) %>%
# #'  filter(heiti == 'Ljósafell') %>%
# #'  rename(skip=skip_nr) %>%
# #'  left_join(lesa_stodvar(mar)) %>%
# #'  filter(dags > i_gildi,dags<ur_gildi) %>%
# #'  select(i_gildi,ur_gildi,dags)
lesa_skipaskra <- function(mar) {

  d <- tbl_mar(mar, "orri.skipaskra")

  return(d)

}

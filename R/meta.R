#' lesa veiðarfæri
#'
#' @param con db connection
#'
#' @name lesa_veidarfaeri
#'
#' @return db query object
#' @export
#'
lesa_veidarfaeri <- function(con) {

  tbl_mar(con, "orri.veidarfaeri") %>%
    dplyr::select(-c(snt:sbn))

}

#' lesa tegundir
#'
#' @name lesa_tegundir
#'
#' @param con db connection
#'
#' @return db query object
#' @export
#'

lesa_tegundir <- function(con){
  tbl_mar(con, "orri.fisktegundir") %>%
    dplyr::select(-c(snt:sbn))
}

#' lesa synaflokka
#'
#' @name lesa_synaflokkar
#'
#' @param con db connection
#'
#' @return db query object
#' @export
#'

lesa_synaflokkar <- function(con){
  tbl_mar(con, "fiskar.synaflokkar")
}


#' londundarhofn
#'
#' @param con db connection
#'
#' @name kvoti_stadur
#'
#' @return db query object
#'
kvoti_stadur <- function(con) {

  tbl_mar(con, "kvoti.stadur")

}

#' Orðabók
#'
#' Flettir upp í sjávardýraorðbókinni á Hafró vefnum
#'
#' @name ordabok
#'
#' @param con connection to Oracle
#'
#' @return db query object
#' @export
ordabok <- function(con){
  tbl_mar(con, "orri.ordabok") %>%
    dplyr::left_join(tbl_mar(con, "orri.ordabok_mal")) %>%
    dplyr::select(tegund = nafn,erlent_heiti = heiti,tungumal=nafn_mals,skammst)
}


#' @title Skipasaga
#'
#' @description XXX
#'
#' @name lods_skipasaga
#'
#' @param con src_oracle tenging við oracle
#' @export
lods_skipasaga <- function(con) {

  d <- tbl_mar(con, "kvoti.skipasaga") %>%
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
#' @param con src_oracle tenging við oracle
# #' @example
# #' con <- dplyrOracle::src_oracle(dbname='sjor')
# #' mar:::lods_skipasaga(con) %>%
# #'  filter(heiti == 'Ljósafell') %>%
# #'  rename(skip=skip_nr) %>%
# #'  left_join(lesa_stodvar(con)) %>%
# #'  filter(dags > i_gildi,dags<ur_gildi) %>%
# #'  select(i_gildi,ur_gildi,dags)
lesa_skipaskra <- function(con) {

  d <- tbl_mar(con, "orri.skipaskra")

  return(d)

}

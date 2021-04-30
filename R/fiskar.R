#' Stodvarupplysingar
#'
#' @name lesa_stodvar
#'
#' @description Fallid myndar tengingu við "view" toflu v_stodvar
#' í fiskar gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

lesa_stodvar <- function(con) {
  tbl_mar(con,'fiskar.stodvar_mar_v') %>%
    dplyr::mutate(lon = ifelse(is.na(hift_v_lengd),
                               kastad_v_lengd,
                               (kastad_v_lengd + hift_v_lengd) / 2),
                  lat = ifelse(is.na(hift_n_breidd),
                               kastad_n_breidd,
                               (kastad_n_breidd + hift_n_breidd) / 2)) %>%
    dplyr::mutate(reitur = nvl(reitur, d2r(lat,lon)),
                  smareitur = nvl(smareitur,d2sr(lat,lon)-10*d2r(lat,lon)))
}




#' Lengdarmaelingar
#'
#' @name lesa_lengdir
#'
#' @description Fallid myndar tengingu við toflu lengdir
#' í fiskar gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

lesa_lengdir <- function(con) {

  d <-
    tbl_mar(con,"fiskar.lengdir") %>%
    dplyr::select(-c(snn:sbt))

  return(d)

}


#' Talningar
#'
#' @name lesa_numer
#'
#' @description Fallid myndar tengingu við toflu numer
#' í fiskar gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

lesa_numer <- function(con) {

  d <-
    tbl_mar(con,"fiskar.numer") %>%
    dplyr::rename(aths_numer = athuga) %>%
    dplyr::select(-c(sbn:snt,dplyr::starts_with('innsl'))) %>%
    dplyr::mutate(uppruni_numer = 'numer')

  return(d)

}


#' Kvarnir
#'
#' @name lesa_kvarnir
#'
#' @description Fallid myndar tengingu við toflu kvarnir
#' í fiskar gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

lesa_kvarnir <- function(con) {

 d <-
    tbl_mar(con,"fiskar.kvarnir") %>%
    dplyr::select(-c(sbn:snt)) %>%
    dplyr::rename(syking = sy) %>%
    dplyr::mutate(uppruni_kvarnir = 'kvarnir') %>%
    dplyr::rename(aths_kvarnir = aths)

  return(d)

}


#' Skala með töldum
#'
#' Þetta fall skala lengdardreifingar með töldum fiskum úr ralli
#'
#' @name skala_med_toldum
#'
#' @param lengdir fyrirspurn á fiskar.lengdir
#'
#' @return fyrirspurn með sköluðum fjölda í lengdarbili
#' @export
skala_med_toldum <- function(lengdir){

  ratio <-
    lesa_numer(lengdir$src) %>%
    dplyr::mutate(fj_maelt = nvl(fj_maelt,1)) %>%
    dplyr::mutate(r = ifelse(nvl(fj_talid,0)==0 ,1,
                             1 + fj_talid/ifelse(fj_maelt>0,fj_maelt,1))) %>%
    dplyr::select(synis_id, tegund, r)

  lengdir %>%
    dplyr::left_join(ratio) %>%
    dplyr::mutate(fjoldi_oskalad = fjoldi) %>%
    dplyr::mutate(fjoldi = fjoldi * r)
}

#' Skala með toglengd
#'
#' Þetta fall skala lengdardreifingar með toglengd úr ralli
#'
#' @name skala_med_toglengd
#'
#' @param lengdir fyrirspurn á fiskar.lengdir
#'
#' @return fyrirspurn með sköluðum fjölda í lengdarbili
#' @export
skala_med_toglengd <- function(st_len,
                               min_towlength = 2,
                               max_towlength = 8,
                               std_towlength = 4){
  st_len %>%
    dplyr::mutate(toglengd = dplyr::if_else(toglengd > max_towlength, max_towlength, toglengd),
           toglengd = dplyr::if_else(toglengd < min_towlength, min_towlength, toglengd)) %>%
    dplyr::mutate(fjoldi = fjoldi * std_towlength/toglengd)
}

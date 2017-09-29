#' Stodvarupplysingar
#'
#' @description Fallid myndar tengingu við "view" toflu v_stodvar
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_stodvar(mar))
lesa_stodvar <- function(mar) {

  st <-
    tbl_mar(mar,"fiskar.stodvar") %>%
    dplyr::select(-c(snt:sbn))
  tog <-
    tbl_mar(mar,"fiskar.togstodvar")%>%
    dplyr::select(-c(snt:sbn))
  um <-
    tbl_mar(mar,"fiskar.umhverfi")%>%
    dplyr::select(-c(snt:sbn))

  d <-
    st %>%
    dplyr::left_join(tog, by = "synis_id") %>%
    dplyr::left_join(um, by = "synis_id") %>%
    dplyr::rename(aths_stodvar = aths) %>%
    dplyr::rename(fj_reitur=fjardarreitur) #%>%
    #fix_pos(col.names=c('kastad_n_breidd','kastad_v_lengd',
    #                    'hift_n_breidd','hift_v_lengd'))

  return(d)

}




#' Lengdarmaelingar
#'
#' @description Fallid myndar tengingu við toflu lengdir
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_lengdir(mar))
lesa_lengdir <- function(mar) {

  d <-
    tbl_mar(mar,"fiskar.lengdir") %>%
    dplyr::select(-c(snn:sbt))

  return(d)

}


#' Talningar
#'
#' @description Fallid myndar tengingu við toflu numer
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_numer(mar))
lesa_numer <- function(mar) {

  d <-
    tbl_mar(mar,"fiskar.numer") %>%
    dplyr::rename(aths_numer = athuga) %>%
    dplyr::select(-c(sbn:snt,dplyr::starts_with('innsl'))) %>%
    dplyr::mutate(uppruni_numer = 'numer')

  return(d)

}


#' Kvarnir
#'
#' @description Fallid myndar tengingu við toflu kvarnir
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_numer(mar))
lesa_kvarnir <- function(mar) {

 d <-
    tbl_mar(mar,"fiskar.kvarnir") %>%
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
#' @param lengdir fyrirspurn á fiskar.lengdir
#'
#' @return fyrirspurn með sköluðum fjölda í lengdarbili
#' @export
#'
#' @examples
skala_med_toldum <- function(lengdir){

  ratio <-
    lesa_numer(lengdir$src) %>%
    dplyr::mutate(r = ifelse(fj_talid==0, 1, fj_talid / ifelse(fj_maelt == 0, 1, fj_maelt))) %>%
    dplyr::select(synis_id, tegund, r)

  lengdir %>%
    dplyr::left_join(ratio) %>%
    dplyr::mutate(fjoldi = fjoldi * r)
}






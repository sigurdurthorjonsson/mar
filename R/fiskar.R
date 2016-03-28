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
  d <-
    dplyr::tbl(mar,dplyr::sql("fiskar.v_stodvar")) %>%
    dplyr::select(synis.id = SYNIS_ID,
                  leidangur = LEIDANGUR,
                  skip.nr = SKIP_NR,
                  stod = STOD,
                  dags = DAGS,
                  reitur = REITUR,
                  smareitur = SMAREITUR,
                  hnattstada = HNATTSTADA,
                  kastad.breidd = KASTAD_BREIDD,
                  kastad.lengd = KASTAD_LENGD,
                  hift.breidd = HIFT_BREIDD,
                  hift.lengd = HIFT_LENGD,
                  dypi.kastad = DYPI_KASTAD,
                  dypi.hift = DYPI_HIFT,
                  veidarf = VEIDARF,
                  moskvastaerd = MOSKVASTAERD,
                  grandaralengd = GRANDARALENGD,
                  heildarafli = HEILDARAFLI,
                  l.hofn = L_HOFN,
                  landsyni = LANDSYNI,
                  skiki = SKIKI,
                  fj.reitur = FJ_REITUR,
                  aths = ATHS,
                  togbyrjun = TOGBYRJUN,
                  togendir = TOGENDIR,
                  toghradi = TOGHRADI,
                  toglengd = TOGLENGD,
                  vir.uti = VIR_UTI,
                  lodrett.opnun = LODRETT_OPNUN,
                  togtimi = TOGTIMI,
                  togdypi.kastad = TOGDYPI_KASTAD,
                  togdypi.hift = TOGDYPI_HIFT,
                  togdypishiti = TOGDYPISHITI,
                  eykt = EYKT,
                  kl.byrjun = KL_BYRJUN,
                  kl.endir = KL_ENDIR,
                  vindhradi = VINDHRADI,
                  vindatt = VINDATT,
                  vedur = VEDUR,
                  sky = SKY,
                  sjor = SJOR,
                  botnhiti = BOTNHITI,
                  yfirb.hiti = YFIRB_HITI,
                  lofthiti = LOFTHITI,
                  loftvog = LOFTVOG,
                  hafis = HAFIS,
                  straumstefna = STRAUMSTEFNA,
                  straumhradi = STRAUMHRADI,
                  sjondypi = SJONDYPI) %>%
    dplyr::mutate(ar =   to_number(to_char(dags, "YYYY")),
                  man =  to_number(to_char(dags, "MM")))

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
    dplyr::tbl(mar,dplyr::sql("fiskar.lengdir")) %>%
    dplyr::select(synis.id = SYNIS_ID,
                  tegund = TEGUND,
                  lengd = LENGD,
                  fjoldi = FJOLDI,
                  kyn = KYN,
                  kynthroski = KYNTHROSKI)

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
    dplyr::tbl(mar,dplyr::sql("fiskar.numer")) %>%
    dplyr::select(synis.id = SYNIS_ID,
                  tegund = TEGUND,
                  fj.maelt = FJ_MAELT,
                  fj.kvarnad = FJ_KVARNAD,
                  fj.talid = FJ_TALID,
                  fj.kyngreint = FJ_KYNGREINT,
                  fj.magasyna = FJ_MAGASYNA,
                  fj.merkt = FJ_MERKT,
                  fj.aldursgr = FJ_ALDURSGR) #%>%
  # below returns an error
    #dplyr::mutate(r = 1 + fj.talid/fj.maelt)

  return(d)

}

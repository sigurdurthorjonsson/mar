#' afli.stofn
#'
#' @description Fallid myndar tengingu við toflu stofn í
#' afli gagnagrunninum. Grásleppan er alveg sér á parti ennþá
#'
#' @name afli_stofn
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export

afli_stofn <- function(mar) {
    tbl_mar(mar, "afli.stofn") %>%
    dplyr::mutate(ar =   to_number(to_char(vedags, "YYYY")),
                  man =  to_number(to_char(vedags, "MM")),
                  lengd = -lengd*100,
                  breidd = breidd*100,
                  lengd_lok = -lengd_lok*100,
                  breidd_lok = breidd_lok*100,
                  smareitur = nvl(smareitur,1)) %>%  ## ath
    geoconvert(col.names = c('lengd','breidd','lengd_lok','breidd_lok')) %>%
    dplyr::left_join(tbl_mar(mar,'fiskar.reitir'),by = c('reitur','smareitur')) %>%
    dplyr::mutate(lengd = nvl(lengd,lon),
                  breidd = nvl(breidd,lat)) %>%
    dplyr::mutate(toglengd = arcdist(breidd,lengd,breidd_lok,lengd_lok)) %>%
    dplyr::select(-c(lat,lon))
}

#' afli.afli
#'
#' @description Fallid myndar tengingu við toflu afli í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @name afli_afli
#'
#' @return dataframe
#' @export
#'
afli_afli <- function(mar) {

  tbl_mar(mar,"afli.afli")

}

#' afli.sjálfvirkir_maelar
#'
#' @description Fallid myndar tengingu við toflu sjálfvirkir_maelar í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @name afli_sjalfvirkir_maelar
#'
#' @return dataframe
#' @export
afli_sjalfvirkir_maelar <- function(mar) {

  d <- tbl_mar(mar, "afli.sjalfvirkir_maelar") %>%
    dplyr::mutate(ar =   to_number(to_char(timi, "YYYY")),
                  man =  to_number(to_char(timi, "MM")),
                  hnattstada_siriti = sign(lengd)) %>%
    dplyr::left_join(afli_stofn(mar) %>%
                       dplyr::mutate(hnattstada_stofn = -sign(lengd)) %>%
                       dplyr::select(visir, veidarf, hnattstada_stofn),
              by = "visir") %>%
    # if hnattstada_stofn is undefined, visir is not found in stofn
    #   this should not really be possible
    dplyr::mutate(hnattstada_stofn = nvl(hnattstada_stofn, 1),
                  lengd = lengd * hnattstada_stofn * hnattstada_siriti)

  return(d)

}

#' afli.toga
#'
#' @description Fallid myndar tengingu við toflu toga í
#' afli gagnagrunninum.
#'
#' @name afli_toga
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_toga <- function(mar) {

  tbl_mar(mar,"afli.toga")

}

#' afli.lineha
#'
#' @description Fallid myndar tengingu við toflu linea í
#' afli gagnagrunninum.
#'
#' @name afli_lineha
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_lineha <- function(mar) {
    tbl_mar(mar,"afli.lineha")
}


#' Grásleppunet
#'
#' @param mar connection to Oracle
#'
#' @name afli_grasl
#'
#' @export
afli_grasl <- function(mar){
  grasl <-
    tbl_mar(mar,'afli.grasl_sokn') %>%
    dplyr::mutate(sr = round(reitur/10,0),
                  uppruni_grasl = 'grasl_sokn') %>%
    dplyr::select(-vear)

  g <-
    tbl_mar(mar,'afli.g_sokn') %>%
    dplyr::mutate(sr = reitur,
           reitur = 10*reitur,
           uppruni_grasl = 'g_sokn',
           athugasemd = '') %>%
    dplyr::select_(.dots = colnames(grasl))

  dplyr::union_all(grasl,g) %>%
    sr2d() %>%
    dplyr::select(-sr) %>%
    dplyr::mutate(ar=to_char(vedags,'YYYY'),
                  man=to_char(vedags,'MM')) %>%
    dplyr::left_join(tbl_mar(mar,'afli.grasleppureitur'), by = 'reitur') %>%
    dplyr::rename(veidisvaedi = bokst_rel)
  }

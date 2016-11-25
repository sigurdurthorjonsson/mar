#' afli.stofn
#'
#' @description Fallid myndar tengingu við toflu stofn í
#' afli gagnagrunninum. Grásleppan er alveg sér á parti ennþá
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export

afli_stofn <- function(mar) {

  tmp_func <- function(data){
    txt <- setdiff(colnames(stofn),colnames(data))
    tmp <- rep('NA_real_',length(txt))
    dplyr::mutate_(data,.dots = setNames(tmp,txt)) %>%
      dplyr::select_(.dots = colnames(stofn))
  }

  stofn <-
    tbl_mar(mar, "afli.stofn") %>%
    dplyr::mutate(uppruni_stofn = 'afli.stofn')

  smuga <-
    tbl_mar(mar,'afli.smuga_stofn') %>%
    dplyr::mutate(visir = visir+1e9,
                  uppruni_stofn = 'afli.smuga_stofn',
                  aths_texti = '') %>%
    tmp_func()


  inn <-
    tbl_mar(mar,'afli.inn_stofn') %>%
    dplyr::mutate(visir = visir+2e9,
                  uppruni_stofn = 'afli.inn_stofn',
                  aths_texti = '') %>%
    tmp_func()


  flem <-
    tbl_mar(mar,'afli.flem_stofn') %>%
    dplyr::mutate(visir = visir+3e9,
                  uppruni_stofn = 'afli.flem_stofn',
                  aths_texti = '') %>%
    tmp_func()

  plog <-
    tbl_mar(mar,'afli.plog_stofn') %>%
    dplyr::mutate(visir = visir+4e9,
                  uppruni_stofn = 'afli.plog_stofn',
                  aths_texti = '') %>%
    tmp_func()


  stofn %>%
    union_all(smuga) %>%
    union_all(inn) %>%
    union_all(plog) %>%
    union_all(inn) %>%
    dplyr::mutate(ar =   to_number(to_char(vedags, "YYYY")),
                  man =  to_number(to_char(vedags, "MM")))


  # ## grásleppan er alveg sér
  # grasl <-
  #   tbl_mar(mar,'afli.grasl_stofn') %>%
  #   dplyr::mutate(visir = visir+1e9,
  #                 uppruni_stofn = 'afli.smuga_stofn')
  # g <-
  #   tbl_mar(mar,'afli.g_stofn') %>%
  #   dplyr::mutate(visir = visir+1e9,
  #                 uppruni_stofn = 'afli.smuga_stofn')
  #
  #
  #

  return(d)

}

#' afli.afli
#'
#' @description Fallid myndar tengingu við toflu afli í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_afli <- function(mar) {

  d <- tbl_mar(mar,"afli.afli")

  return(d)

}

#' afli.sjálfvirkir_maelar
#'
#' @description Fallid myndar tengingu við toflu sjálfvirkir_maelar í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
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
                       dplyr::select(visir, veidarfaeri, hnattstada_stofn),
              by = "visir") %>%
    # if hnattstada_stofn is undefined, visir is not found in stofn
    #   this should not really be possible
    dplyr::mutate(hnattstada_stofn = ifelse(is.na(hnattstada_stofn), 1, hnattstada_stofn),
           lengd = lengd * hnattstada_stofn * hnattstada_siriti)

  return(d)

}

#' afli.toga
#'
#' @description Fallid myndar tengingu við toflu toga í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_toga <- function(mar) {

  d <- tbl_mar(mar,"afli.toga")

  return(d)

}

#' afli.lineha
#'
#' @description Fallid myndar tengingu við toflu linea í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_lineha <- function(mar) {

  d <- tbl_mar(mar,"afli.lineha")

  return(d)

}

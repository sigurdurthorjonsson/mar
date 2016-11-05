#' afli.stofn
#'
#' @description Fallid myndar tengingu við toflu stofn í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export

afli_stofn <- function(mar) {

  d <- tbl_mar(mar, "afli.stofn") %>%
    dplyr::rename(veidarfaeri = veidarf) %>%
    dplyr::mutate(ar =   to_number(to_char(vedags, "YYYY")),
                  man =  to_number(to_char(vedags, "MM")))

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

  d <- tbl_mar(mar,"afli.toga")

  return(d)

}

#' @title oracle afli_stofn
#'
#' @description XXX
#'
#' @export
#'
#' @param mar tenging við oraclegrunn
afli_stofn <- function(mar) {

  d <- tbl_mar(mar, "afli.stofn") %>%
    dplyr::rename(veidarfaeri = veidarf) %>%
    dplyr::mutate(ar =   to_number(to_char(vedags, "YYYY")),
                  man =  to_number(to_char(vedags, "MM")))

  return(d)

}

#' @title oracle afli_afli
#'
#' @description XXX
#'
#' @export
#'
#' @param mar tenging við oraclegrunn
afli_afli <- function(mar) {

  d <- tbl_mar(mar,"afli.afli")

  return(d)

}

#' @title oracle afli_siriti
#'
#' @description XXX
#'
#' @export
#'
#' @param mar tenging við oraclegrunn
afli_siriti <- function(mar) {

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

#' @title oracle afli_toga
#'
#' @description XXX
#'
#' @export
#'
#' @param mar tenging við oraclegrunn
afli_toga <- function(mar) {

  d <- tbl_mar(mar,"afli.toga")

  return(d)

}


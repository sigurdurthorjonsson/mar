#' @title stofn
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
afli_stofn <- function(mar) {

  d <- dplyr::tbl(mar,dplyr::sql("afli.stofn")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.)))) %>%
    dplyr::rename(veidarfaeri = veidarf) %>%
    dplyr::mutate(ar =   to_number(to_char(vedags, "YYYY")),
                  man =  to_number(to_char(vedags, "MM")))

  return(d)

}

#' @title afli
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
afli_afli <- function(mar) {

  d <- dplyr::tbl(mar,dplyr::sql("afli.afli")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))

  return(d)

}

#' @title siriti
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
afli_siriti <- function(mar) {

  d <- dplyr::tbl(mar,dplyr::sql("afli.sjalfvirkir_maelar")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.)))) %>%
    dplyr::mutate(ar =   to_number(to_char(timi, "YYYY")),
                  man =  to_number(to_char(timi, "MM")),
                  hnattstada_siriti = sign(lengd)) %>%
    left_join(afli_stofn(mar) %>%
                mutate(hnattstada_stofn = -sign(lengd)) %>%
                select(visir, veidarfaeri, hnattstada_stofn),
              by = "visir") %>%
    # if hnattstada_stofn is undefined, visir is not found in stofn
    #   this should not really be possible
    mutate(hnattstada_stofn = ifelse(is.na(hnattstada_stofn), 1, hnattstada_stofn),
           lengd = lengd * hnattstada_stofn * hnattstada_siriti)

  return(d)

}

#' @title toga
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
afli_toga <- function(mar) {

  d <- dplyr::tbl(mar,dplyr::sql("afli.toga")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))

  return(d)

}


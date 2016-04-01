#' @title Landadur afli
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
lods_oslaegt <- function(mar) {

  d <- dplyr::tbl(mar,dplyr::sql("kvoti.lods_oslaegt")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.)))) %>%
    dplyr::rename(veidarfaeri = veidarf) %>%
    dplyr::mutate(ar =   to_number(to_char(l_dags, "YYYY")),
                  man =  to_number(to_char(l_dags, "MM")))
    # This would be nice
    #dplyr::mutate(magn = dplyr::ifelse(fteg %in% c(30, 31) & ar < 1993,
    #                                    magn_oslaegt/1000,
    #                                    magn_oslaegt))

    # Also to create a category of foreign vessels (based on skip_nr)


    return(d)
}

#' @title Skipasaga
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
lods_skipasaga <- function(mar) {

    d <- dplyr::tbl(mar,dplyr::sql("kvoti.skipasaga")) %>%
      dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.)))) %>%
      dplyr::select(-(snt:sbn))

  return(d)

}

#' @title Skipaskra
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
skipaskra <- function(mar) {

  d <- dplyr::tbl(mar, dplyr::sql("orri.skipaskra")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))

  return(d)

}
#' @title Landadur afli
#'
#' @description Landaður afli. Dálkurinn flokkur vísar til skipaflokks,
#' ef neikvæður þá er um erlent skip að ræða. Erlend skip eru
#' einnig þegar þetta er skrifað (1. apríl 2016) með númer frá 3815:4999.
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
landadur_afli <- function(mar) {

  d <-
    lods_oslaegt(mar) %>%
    dplyr::left_join(skipaskra(mar) %>%
                       dplyr::select(skip_nr, flokkur),
                     by = "skip_nr")

  return(d)

}


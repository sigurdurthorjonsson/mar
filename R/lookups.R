#' Lookup species
#'
#' @param con Oracle connection
#'
#' @return a query
#'
lu_species <- function(con) {

  lesa_tegundir(con) %>%
    dplyr::select(sid = tegund,
                  tegund = heiti,
                  species = enskt_heiti)

}

#' Lookup gear
#'
#' @param con Oracle connection
#'
#' @return a query
#'
lu_gear <- function(con) {

    lesa_veidarfaeri(con) %>%
    dplyr::select(gid = veidarfaeri,
                  veiðarfæri = lysing,
                  gear = lysing_enska)

}

#' Lookup harbour
#'
#' @param con Oracle connection
#'
#' @return a query
#'
lu_harbour <- function(con) {

  tbl_mar(con, "kvoti.stadur") %>%
    dplyr::select(hid = stad_nr,
                  harbour = heiti,
                  landing = londunar_hofn)

}

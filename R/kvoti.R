
#' Heimild
#'
#' @param con src_oracle tenging við oracle
#'
heimild <- function(con) {

  d <-   tbl_mar(con, "kvoti.heimild")

  return(d)

}

#' Aflaheimild
#'
#' @param con src_oracle tenging við oracle
#'
afla_heimild <- function(con) {

  d <-
    tbl_mar(con, "kvoti.afla_heimild") %>%
    dplyr::select(-c(sng:sbt)) %>%
    dplyr::mutate(ar =   to_number(to_char(i_gildi, "YYYY")),
           man =  to_number(to_char(i_gildi, "MM")),
           timabil = dplyr::if_else(to_number(to_char(i_gildi, "MM")) < 9,
                             concat(to_number(to_char(i_gildi, "YY")) -1, to_number(to_char(i_gildi, "YY"))),
                             concat(to_number(to_char(i_gildi, "YY")), to_number(to_char(i_gildi, "YY")) + 1))) %>%
    dplyr::left_join(heimild(con), by = c("heimild" = "tegund")) %>%
    dplyr::left_join(kvoti_studlar(con) %>% dplyr::select(ftegund, timabil, i_oslaegt), by = c("ftegund", "timabil")) %>%
    dplyr::mutate(oslaegt = i_oslaegt * magn)

  return(d)

}

#' Úthlutun kvóta
#'
#' @param con src_oracle tenging við oracle
#' @export
kvoti_uthlutanir <- function(con) {
  tbl_mar(con, "kvoti.uthlutanir") %>%
    select(tilvisun:ath, id:lokid)
}


#' Heimild
#'
#' @param mar src_oracle tenging við oracle
#'
#' @export
heimild <- function(mar) {

  d <-   tbl_mar(mar, "kvoti.heimild")

  return(d)

}

#' Aflaheimild
#'
#' @param mar src_oracle tenging við oracle
#'
#' @export
afla_heimild <- function(mar) {

  d <-
    tbl_mar(mar, "kvoti.afla_heimild") %>%
    dplyr::select(-c(sng:sbt)) %>%
    dplyr::mutate(ar =   to_number(to_char(i_gildi, "YYYY")),
           man =  to_number(to_char(i_gildi, "MM")),
           timabil = dplyr::if_else(to_number(to_char(i_gildi, "MM")) < 9,
                             concat(to_number(to_char(i_gildi, "YY")) -1, to_number(to_char(i_gildi, "YY"))),
                             concat(to_number(to_char(i_gildi, "YY")), to_number(to_char(i_gildi, "YY")) + 1))) %>%
    dplyr::left_join(heimild(mar), by = c("heimild" = "tegund")) %>%
    dplyr::left_join(kvoti_studlar(mar) %>% dplyr::select(ftegund, timabil, i_oslaegt), by = c("ftegund", "timabil")) %>%
    dplyr::mutate(oslaegt = i_oslaegt * magn)

  return(d)

}

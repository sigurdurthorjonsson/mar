
#' Heimild
#'
#' @param mar src_oracle tenging við oracle
#'
#' @export
heimild <- function(mar) {

  d <-   tbl(mar, sql("kvoti.heimild")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))

  return(d)

}

#' Aflaheimild
#'
#' @param mar src_oracle tenging við oracle
#'
#' @export
afla_heimild <- function(mar) {

  d <-
    tbl(mar, sql("kvoti.afla_heimild")) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.)))) %>%
    select(-c(sng:sbt)) %>%
    mutate(ar =   to_number(to_char(i_gildi, "YYYY")),
           man =  to_number(to_char(i_gildi, "MM")),
           timabil = if_else(to_number(to_char(i_gildi, "MM")) < 9,
                             concat(to_number(to_char(i_gildi, "YY")) -1, to_number(to_char(i_gildi, "YY"))),
                             concat(to_number(to_char(i_gildi, "YY")), to_number(to_char(i_gildi, "YY")) + 1))) %>%
    left_join(heimild(mar), by = c("heimild" = "tegund")) %>%
    left_join(kvoti_studlar(mar) %>% select(ftegund, timabil, i_oslaegt), by = c("ftegund", "timabil")) %>%
    mutate(oslaegt = i_oslaegt * magn)

  return(d)

}

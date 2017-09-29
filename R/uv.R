#' @export
uv_veidisvaedi <- function(con) {
  tbl_mar(con, "uv.veidisvaedi") %>%
    # fs_skyring is not readable into R
    dplyr::select(-c(snt:sbg, fs_skyring)) %>%
    dplyr::mutate(ar = to_number(to_char(dags_fra, "YYYY")))
}

#' @export
uv_hnit <- function(con) {
  tbl_mar(con, "uv.hnit") %>%
    dplyr::rename(hnit_id = id) %>%
    dplyr::rename(id = veidisv)
}

#' @export
uv_tegund <- function(con) {
  d <-
    tbl_mar(con, "uv.veidisv_fteg") %>%
    dplyr::select(fteg_id = fteg,
                  id = veidisv_id)
  d2 <-
    tbl_mar(con, "uv.fteg") %>%
    dplyr::select(fteg_id = id, tegund, fiskheiti = heiti)
  d %>%
    dplyr::left_join(d2, by = "fteg_id") %>%
    dplyr::select(-fteg_id)
}


#' @export
uv_veidarfaeri <- function(con) {
  d <-
    tbl_mar(con, "uv.veidisv_veidarf") %>%
    dplyr::select(id = veidisv_id,
                  veidarf_id = veidarf)
  d2 <-
    tbl_mar(con, "uv.veidarfa") %>%
    dplyr::select(-c(snt:sbg)) %>%
    dplyr::select(veidarf_id = id, veidarfaeri = heiti)
  d %>%
    dplyr::left_join(d2, by = "veidarf_id") %>%
    dplyr::select(-veidarf_id)
}

#' @export
uv_flatfile <- function(con) {
  uv_veidisvaedi(con) %>%
    dplyr::left_join(uv_tegund(con), by = "id") %>%
    dplyr::left_join(uv_veidarfaeri(con), by = "id")
}

#' @export
get_skyndilokun <- function(con, year, nr) {

  stofn <-
    uv_veidisvaedi(con) %>%
    dplyr::filter(teg_veidisvaeda == "Skyndilokun",
                  ar %in% year)

  if(!missing(nr)) {
    nr <- as.character(nr)
    nr <- paste0(c("","0","00","000"),nr)
    stofn <-
      stofn %>%
      dplyr::filter(heiti %in% nr)
  }

  hnit <-
    stofn %>%
    dplyr::left_join(uv_hnit(con), by = "id") %>%
    mar:::geoconvert(col.names = c("hnit_n", "hnit_v")) %>%
    dplyr::rename(lon = hnit_v, lat = hnit_n) %>%
    dplyr::mutate(lon = -lon)

  return(hnit)
}


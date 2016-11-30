#' @export
uv_veidisvaedi <- function(db) {
  dplyr::tbl_mar(db, "uv.veidisvaedi") %>%
    # fs_skyring is not readable into R
    dplyr::select(-c(snt:sbg, fs_skyring)) %>%
    dplyr::mutate(ar = to_number(to_char(dags_fra, "YYYY")))
}
#' @export
uv_hnit <- function(db) {
  dplyr::tbl_mar(db, "uv.hnit") %>%
    dplyr::rename(hnit_id = id,
                  id = veidisv)
}
#' @export
uv_veidisv_fteg <- function(db) {
  d <-
    dplyr::tbl_mar(db, "uv.veidisv_fteg") %>%
    dplyr::select(fteg_id = fteg,
                  id = veidisv_id)
  d2 <-
    dplyr::tbl_mar(db, "uv.fteg") %>%
    dplyr::select(fteg_id = id, tegund, fiskheiti = heiti)
  d %>%
    dplyr::left_join(d2) %>%
    dplyr::select(-fteg_id)
}


#' @export
uv_veidisv_veidarf <- function(db) {
  d <-
    dplyr::tbl_mar(db, "uv.veidisv_veidarf") %>%
    dplyr::select(id = veidisv_id,
                  veidarf_id = veidarf)
  d2 <-
    dplyr::tbl_mar(db, "uv.veidarfa") %>%
    dplyr::select(-c(snt:sbg)) %>%
    dplyr::select(veidarf_id = id, veidarfaeri = heiti)
  d %>%
    dplyr::left_join(d2) %>%
    dplyr::select(-veidarf_id)
}


#' @export
uv_veidarfa <- function(db) {
  dplyr::tbl_mar(db, "uv.veidarfa") %>%
    dplyr::select(-c(snt:sbg))
}

uv_flat_file <- function(db) {
  uv_veidisvaedi(db) %>%
    #filter(teg_veidisvaeda == "Skyndilokun") %>%
    dplyr::left_join(uv_veidisv_fteg(db)) %>%
    dplyr::left_join(uv_veidisv_veidarf(db)) %>%
    dplyr::collect(n = Inf)
}

get_skyndilokun <- function(db, year, nr) {

  stofn <-
    uv_veidisvaedi(db) %>%
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
    dplyr::left_join(uv_hnit(db), by = "id") %>%
    mar:::geoconvert(col.names = c("hnit_n", "hnit_v")) %>%
    dplyr::rename(lon = hnit_v, lat = hnit_n) %>%
    dplyr::mutate(lon = -lon)

  return(hnit)
}


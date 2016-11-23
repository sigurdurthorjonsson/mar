#' @export
uv_veidisvaedi <- function(db) {
  tbl_mar(db, "uv.veidisvaedi") %>%
    dplyr::select(-c(snt:sbg)) %>%
    mutate(ar = to_number(to_char(dags_fra, "YYYY")))
}
#' @export
uv_hnit <- function(db) {
  tbl_mar(db, "uv.hnit") %>%
    rename(hnit_id = id,
           id = veidisv)
}
#' @export
uv_veidisv_fteg <- function(db) {
  tbl_mar(db, "uv.veidisv_fteg") %>%
    rename(fteg_id = id,
           id = veidisv_id)
}
#' @export
uv_veidisv_veidarf <- function(db) {
  tbl_mar(db, "uv.veidisv_veidarf")
}
#' @export
uv_veidarfa <- function(db) {
  tbl_mar(db, "uv.veidarfa") %>%
  dplyr::select(-c(snt:sbg))
}

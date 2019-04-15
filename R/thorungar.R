thorungar_botnthorungar <- function(db) {

  tbl_mar(db, "thorungar.botnthorungar") %>%
    dplyr::mutate(ar =   to_number(to_char(dags, "YYYY"))) %>%
    dplyr::select(-c(snt:sbn))

}


botnthorungar_myndir <- function(db) {

  tbl_mar(db, "thorungar.botnthorungar_myndir") %>%
    dplyr::select(-c(snt:sbn))

}


botnthorungar <- function(db) {

  tbl_mar(db, "thorungar.botnthorungar_v")

}


bt_tegundir <- function(db) {
  tbl_mar(db, "thorungar.tegundir_v")
}


bt_tegundir_stadir <- function(db) {
  tbl_mar(db, "thorungar.tegundir_stadir_v")
}

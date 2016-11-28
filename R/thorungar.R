thorungar_botnthorungar <- function(db) {

  tbl_mar(db, "thorungar.botnthorungar") %>%
    dplyr::mutate(ar =   to_number(to_char(dags, "YYYY"))) %>%
    select(-c(snt:sbn))

}

#' @export
botnthorungar_myndir <- function(db) {

  tbl_mar(db, "thorungar.botnthorungar_myndir") %>%
    select(-c(snt:sbn))

}

# views
#' @export
botnthorungar <- function(db) {

  tbl_mar(db, "thorungar.botnthorungar_v")

}

#' @export
bt_tegundir <- function(db) {
  tbl_mar(db, "thorungar.tegundir_v")
}

#' @export
bt_tegundir_stadir <- function(db) {
  tbl_mar(db, "thorungar.tegundir_stadir_v")
}

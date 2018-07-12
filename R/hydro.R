#' @export
hydro_hitamaelar <- function(mar) {
  tbl_mar(mar,"hydro.hitamaelar") %>%
    select(-c(snt:sbn)) %>%
    mutate(ar = to_number(to_char(timi, "YYYY")))
}
#' @export
hydro_stadir <- function(mar) {
  tbl_mar(mar, "hydro.stadir")
}
#' @export
hydro_stodvanofn <- function(mar) {
  tbl_mar(mar, "hydro.stodvanofn") %>%
    mutate(lon = -lengd * 100,
           lat = breidd * 100) %>%
    mar:::geoconvert()
}
#' @export
hydro_observation <- function(mar) {
  tbl_mar(mar, "hydro.observation") %>%
    select(-c(snt:sbn))
}
#' @export
hydro_trolltog <- function(mar) {
  tbl_mar(mar, "hydro.trolltog") %>%
    select(-c(snt:sbn))
}
#' @export
hydro_station <- function(con) {
  tbl_mar(con, "hydro.station") %>%
    select(-c(snt:sbn)) %>%
    mutate(lon =   as.integer(longitude) * 100 + ifelse(is.na(la_sec), 0, as.integer(lo_sec)),
           lat =   as.integer(latitude)  * 100 + ifelse(is.na(lo_sec), 0, as.integer(la_sec))) %>%
    mar:::geoconvert(col.names = c("lon", "lat")) %>%
    mutate(lon = ifelse(lo_id == "W", -lon,  lon),
           lat = ifelse(la_id == "N",  lat, -lat)) %>%
    select(t_id:id, lon, lat, q_cont:name)
}


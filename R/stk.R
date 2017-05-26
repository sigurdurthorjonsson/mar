stk_vms <- function(db) {
  tbl_mar(db, "stk.stk_vms_v") %>%
    dplyr::mutate(year = to_number(to_char(posdate, 'YYYY')),
                  lon = poslon * 45 / atan(1),
                  lat = poslat * 45 / atan(1),
                  heading = heading * 45 / atan(1),
                  speed = speed * 1.852) %>%
    dplyr::select(-poslon, -poslat) %>%
    dplyr::rename(date = posdate)
}

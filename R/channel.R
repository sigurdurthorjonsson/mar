#' Stodvarupplysingar
#'
#' @name stodvar
#'
#' @description Fallid myndar tengingu við "view" toflu stodvar
#' í channel gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

stodvar <- function(mar) {
  tbl_mar(mar,'channel.stodvar') %>%
    dplyr::mutate(lon = ifelse(is.na(hift_v_lengd),
                               kastad_v_lengd,
                               (kastad_v_lengd + hift_v_lengd) / 2),
                  lat = ifelse(is.na(hift_n_breidd),
                               kastad_n_breidd,
                               (kastad_n_breidd + hift_n_breidd) / 2)) %>%
    dplyr::mutate(reitur = nvl(reitur, d2r(lat,lon)),
                  smareitur = nvl(smareitur,d2sr(lat,lon)-10*d2r(lat,lon)))
}

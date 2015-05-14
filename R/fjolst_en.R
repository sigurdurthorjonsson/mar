# ----------------------------------------------------------
# emulating fjolst

#' @title read_stations
#'
#' @description XXX
#'
#' @export
#'
#' @param year XXX
#' @param gid gear id
#' @param month XXX
#' @param sq statistical rectangle
#' @param cruise XXX
#' @param id XXX
read_stations <- function(year = NULL,
                         gid = NULL,
                         month = NULL,
                         sq = NULL,
                         cruise = NULL,
                         id = NULL) {

  mar <- dplyrOracle::src_oracle("mar")

  x3 <- dplyr::tbl(mar,dplyr::sql("fiskar.umhverfi")) %>%
    dplyr::select(-SNT, -SNN, -SBT, -SBN)
  x2 <- dplyr::tbl(mar,dplyr::sql("fiskar.togstodvar")) %>%
    dplyr::select(-SNT,-SNN,-SBT,-SBN,-DREGID_FRA)
  x <- dplyr::tbl(mar,dplyr::sql("fiskar.stodvar")) %>%
    dplyr::select(-SNT,-SNN,-SBN,-SBT) %>%
    dplyr::left_join(x2, by="SYNIS_ID") %>%
    dplyr::left_join(x3, by="SYNIS_ID")
  if(!is.null(year))
    x <- x %>% dplyr::filter(to_char(DAGS,'YYYY') %in% year)
  if(!is.null(gid))
    x <- x %>% dplyr::filter(VEIDARFAERI %in% gid)
  if(!is.null(month))
    x <- x %>% dplyr::filter(to_char(DAGS,'MM') %in% month)
  if(!is.null(sq))
    x <- x %>% dplyr::filter(REITUR %in% sq)
  if(!is.null(cruise))
    x <- x %>% dplyr::filter(LEIDANGUR %in% cruise)
  if(!is.null(id))
    x <- x %>% dplyr::filter(SYNIS_ID %in% id)

  x <- dplyr::collect(x)
  colnames(x) <- tolower(colnames(x))
  x <- x %>%
    dplyr::mutate(lat1 =  geo_convert(kastad_n_breidd),
                  lon1  = -geo_convert(kastad_v_lengd),
                  lat2   =  geo_convert(hift_n_breidd),
                  lon2    = -geo_convert(hift_v_lengd),
                  hnattstada = ifelse(is.na(hnattstada),-1,hnattstada),
                  lat = (lat1 + lat2)/2,  # NA issue
                  lon = (lon1 + lon2)/2)  %>%  # NA issue
    dplyr::select(-c(kastad_n_breidd:hift_v_lengd),-stada_stodvar) %>%
    dplyr::rename(id = synis_id,
           cruise = leidangur,
           date = dags,
           vid = skip,
           station = stod,
           sq = reitur,
           ssq = smareitur,
           z1 = dypi_kastad,
           z2 = dypi_hift,
           gid = veidarfaeri,
           mesh = moskvastaerd,
           grandaralengd = grandaralengd,
           catch = heildarafli,
           lid = londunarhofn,
           skiki = skiki,
           fjardarreitur = fjardarreitur,
           landsyni = landsyni,
           comment = aths,
           sample_class = synaflokkur)


  return(x)
}

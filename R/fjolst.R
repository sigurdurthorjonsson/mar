# ----------------------------------------------------------
# emulating fjolst

#' @title lesa_stodvar
#'
#' @description XXX
#'
#' @export
#'
#' @param ar XXX
#' @param veidarfaeri XXX
#' @param man XXX
#' @param reitur XXX
#' @param leidangur XXX
#' @param synis.id XXX
lesa_stodvar <- function(ar = NULL,
                         veidarfaeri = NULL,
                         man = NULL,
                         reitur = NULL,
                         leidangur = NULL,
                         synis.id = NULL) {

  mar <- dplyrOracle::src_oracle("mar")

  x3 <- dplyr::tbl(mar,dplyr::sql("fiskar.umhverfi")) %>%
    dplyr::select(-SNT, -SNN, -SBT, -SBN)
  x2 <- dplyr::tbl(mar,dplyr::sql("fiskar.togstodvar")) %>%
    dplyr::select(-SNT,-SNN,-SBT,-SBN,-DREGID_FRA)
  x <- dplyr::tbl(mar,dplyr::sql("fiskar.stodvar")) %>%
    dplyr::select(-SNT,-SNN,-SBN,-SBT) %>%
    dplyr::left_join(x2, by="SYNIS_ID") %>%
    dplyr::left_join(x3, by="SYNIS_ID")
  if(!is.null(ar))
    x <- x %>% dplyr::filter(to_char(DAGS,'YYYY') %in% ar)
  if(!is.null(veidarfaeri))
    x <- x %>% dplyr::filter(VEIDARFAERI %in% veidarfaeri)
  if(!is.null(man))
    x <- x %>% dplyr::filter(to_char(DAGS,'MM') %in% man)
  if(!is.null(reitur))
    x <- x %>% dplyr::filter(REITUR %in% reitur)
  if(!is.null(leidangur))
    x <- x %>% dplyr::filter(LEIDANGUR %in% leidangur)
  if(!is.null(synis.id))
    x <- x %>% dplyr::filter(SYNIS_ID %in% synis.id)

  x <- dplyr::collect(x)
  colnames(x) <- tolower(colnames(x))
  x <- x %>%
    dplyr::mutate(ar  = lubridate::year(dags),
           man = lubridate::month(dags),
           dagur = lubridate::month(dags),
           kastad_n_breidd =  geo_convert(kastad_n_breidd),
           kastad_v_lengd  = -geo_convert(kastad_v_lengd),
           hift_n_breidd   =  geo_convert(hift_n_breidd),
           hift_v_lengd    = -geo_convert(hift_v_lengd),
           #kl_kastad  = lubridate::hm(togbyrjun),
           #kl_hift    = lubridate::hm(togendir),
           hnattstada = ifelse(is.na(hnattstada),-1,hnattstada),
           lat = (kastad_n_breidd + hift_n_breidd)/2,  # NA issue
           lon = (kastad_v_lengd + hift_v_lengd)/2)    # NA issue
  return(x)
}


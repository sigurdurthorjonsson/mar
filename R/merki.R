# ------------------------------------------------------------------------------
# Data punched in for Jón Jónsson
# These data are not in schema fiskmerki
# Length at tagging is only reported for fish recaptured

merki_stodvar_jj <- function(con) {
  tbl_mar(con, "merki.merki") %>%
    dplyr::rename(tSkip_nr = skip_nr,
                  tDags = dags,
                  tLon = stad_v,
                  tLat = stad_n,
                  tReitur = reit,
                  tSmareitur = smar,
                  tVeidarfaeri = veidarf,
                  tDypi = dypi) %>%
    dplyr::select(-c(tegund, tegund_merkis:numer_merkis_e)) %>%
    dplyr::mutate(mrk_id = -(merking * 1000 + flokkur),
                  tLon =  -tLon * 100,
                  tLat =   tLat * 100,
                  source = "jj") %>%
    mar:::geoconvert(col.names = c("tLat", "tLon")) %>%
    dplyr::select(-c(merking, flokkur))
}

merki_lengdir_jj <- function(con) {
  tbl_mar(con, "merki.lengd") %>%
    dplyr::rename(audkenni = audk_merkis,
                  numer = numer_merkis,
                  tLengd = lengd,
                  tTegund = tegund) %>%
    dplyr::mutate(mrk_id = -(merking * 1000 + flokkur),
                  tTegund = 1,
                  source = "jj") %>%
    dplyr::select(-c(merking, flokkur, skip_nr))
}


merki_endurheimtur_jj <- function(con) {
  tbl_mar(con, "merki.endur") %>%
    dplyr::rename(audkenni = audk_merkis,
                  numer = numer_merkis,
                  rLon = stad_v,
                  rLat = stad_n,
                  rReitur = reit,
                  rSmareitur = smar,
                  rDags = dags,
                  rVeidarfaeri = veidarf,
                  rDypi = dypi,
                  rLengd = e_lengd,
                  rKyn = kyn,
                  rAldur = aldur) %>%
    dplyr::mutate(ar = to_number(ar) + 1900,
                  rLon = -rLon * 100,
                  rLat =  rLat * 100) %>%
    mar:::geoconvert(col.names = c("rLat", "rLon")) %>%
    dplyr::mutate(rAr = to_number(to_char(rDags, "YYYY")),
                  rAr = ifelse(is.na(rDags), ar, rAr)) %>%
    dplyr::left_join(tbl_mar(con, "merki.tjoderni") %>%
                       dplyr::rename(tjod = kodi,
                                     rNation = skyring)) %>%
    dplyr::mutate(source = "jj",
                  recaptured = 1) %>%
    dplyr::select(-c(nafn:ar, tjod))
}


taggart_jj <- function(con) {

  mar:::merki_stodvar_jj(con) %>%
    dplyr::left_join(mar:::merki_lengdir_jj(con)) %>%
    dplyr::left_join(mar:::merki_endurheimtur_jj(con)) %>%
    dplyr::collect(n = Inf) %>%
    # rPosition: 1 - recapture lon and lat
    #            2 - from reitur-smareitur
    #            3 - from reitur
    dplyr::mutate(rPosition = ifelse(!is.na(rLon),
                                     1,
                                     NA_real_),
                  rSmareitur = ifelse(rSmareitur %in% 1:4,
                                      rSmareitur,
                                      NA_real_),
                  sq = ifelse(is.na(rSmareitur),
                              NA_real_,
                              rReitur * 10 + rSmareitur),
                  rPosition = ifelse(is.na(rPosition) & !is.na(rSmareitur),
                                     2,
                                     rPosition),
                  rLon = ifelse(is.na(rLon),
                                geo::sr2d(sq)$lon,
                                rLon),
                  rLat = ifelse(is.na(rLat),
                                geo::sr2d(sq)$lat,
                                rLat),
                  rPosition = ifelse(is.na(rPosition) & !is.na(rReitur),
                                     3,
                                     rPosition),
                  rLon = ifelse(is.na(rLon),
                                geo::r2d(rReitur)$lon,
                                rLon),
                  rLat = ifelse(is.na(rLat),
                                geo::r2d(rReitur)$lat,
                                rLat)) %>%
    dplyr::select(-sq) %>%
    dplyr:: mutate(das = (rDags - tDags),
                   das = as.duration(das) / ddays(1),
                   mas = floor(das / 30),
                   yas = floor(das / 365))


}

# Note -------------------------------------------------------------------------
#  The data in the following tables should have been migrated to fiskmerki

merki_stodvar <- function(con) {
  tbl_mar(con, "merki.stodvar") %>%
    dplyr::select(-c(tegund, snt:sbn)) %>%
    dplyr::rename(tDags = dags,
                  tReitur = reit,
                  tSmareitur = smar,
                  tVeidarfaeri = veidarf,
                  tDypi = dypi,
                  tLon = vlengd,
                  tLat = nbreidd,
                  tHafsvaedi = haf) %>%
    dplyr::mutate(tLon = -tLon / 100,
                  tLat =  tLat / 100,
                  source = "old")
}

merki_lengdir <- function(con) {
  tbl_mar(con, "merki.lengdir") %>%
    dplyr::select(-c(snt:sbn)) %>%
    dplyr::left_join(tbl_mar(con, "merki.stodvar") %>%
                       dplyr::select(mrk_id, tTegund = tegund)) %>%
    dplyr::rename(tLengd = lengd,
                  tKyn = kyn) %>%
    dplyr::mutate(source = "old")
}

merki_endurheimtur <- function(con) {
  tbl_mar(con, "merki.endurheimt") %>%
    dplyr::rename(rLon = vlengd,
                  rLat = nbreidd,
                  rReitur = reit,
                  rSmareitur = smar,
                  rDags = dags,
                  rVeidarfaeri = veidarf,
                  rDypi = dypi,
                  rLengd = lengd,
                  rKyn = kyn,
                  rKynthroski = kynthroski,
                  rSkip_nr = skip_nr,
                  rAth = ath,
                  rAldur = aldur) %>%
    # Have to do mutate( in stages, otherwise error
    dplyr::mutate(rKyn = to_number(rKyn),
                  ar = to_number(ar) + 1900,
                  man = to_number(man),
                  rLon = -rLon / 100,
                  rLat =  rLat / 100) %>%
    dplyr::mutate(rAr = to_number(to_char(rDags, "YYYY")),
                  rAr = ifelse(is.na(rDags), ar, rAr)) %>%
    dplyr::mutate(rMan = to_number(to_char(rDags, "MM")),
                  rMan = ifelse(is.na(rDags), man, rMan),
                  source = "old") %>%
    dplyr::select(-c(svar_dags, fundarlaun_dags, snt:sbn))
}





merki_hafsvaedi <- function(con) {
  tbl_mar(con, "merki.hafsvaedi")
}



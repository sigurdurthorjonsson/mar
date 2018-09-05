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
                  source = "jj") %>%
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
                  rLon = -rLon / 100,
                  rLat =  rLat / 100) %>%
    dplyr::mutate(rAr = to_number(to_char(rDags, "YYYY")),
                  rAr = ifelse(is.na(rDags), ar, rAr)) %>%
    dplyr::mutate(source = "jj") %>%
    dplyr::select(-c(nafn:ar))
}



merki_hafsvaedi <- function(con) {
  tbl_mar(con, "merki.hafsvaedi")
}



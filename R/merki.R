#' @title merki
#'
#' @description XXX
#'
#' @param mar src_oracle tenging við oracle

fiskmerki_merki <- function(mar) {
  d <- tbl_mar(mar, "fiskmerki.merki") %>%
    dplyr::rename(tid = id)
  return(d)
}

#' @title fiskar
#'
#' @description XXX
#'
#'
#' @param mar src_oracle tenging við oracle
fiskmerki_fiskar <- function(mar) {

  d <- tbl_mar(mar, "fiskmerki.fiskar") %>%
    dplyr::rename(fiskur_id = id)

    return(d)
}

#' @title endurheimtur
#'
#' @description XXX
#'
#'
#' @param mar src_oracle tenging við oracle
fiskmerki_endurheimtur <- function(mar) {
  d <- tbl_mar(mar, "fiskmerki.endurheimtur") %>%
    dplyr::select(rid = id,
                  tid = merki_id,
                  rDags = dags_fundid,
                  rAr = ar,
                  rManudur = manudur,
                  rLon = vlengd,
                  rLat = nbreidd,
                  rReitur = reitur,
                  rSmareitur = smareitur,
                  rLandshluti = landshluti_id,
                  rHafsvaedi = hafsvaedi_id,
                  rVeidarfaeri = veidarfaeri_id,
                  rDypi = dypi,
                  rTegund = tegund,
                  rLengd = lengd,
                  rKyn = kyn,
                  rKynthroski = kynthroski,
                  rAge = aldur) %>%
    mutate(lon = -geoconvert1(rLon * 100),
           lat =  geoconvert1(rLat * 100))

  return(d)
}

#' @title rafaudkenni
#'
#' @description XXX
#'
#'
#' @param mar src_oracle tenging við oracle
fiskmerki_rafaudkenni <- function(mar) {

  d <- tbl_mar(mar, "fiskmerki.rafaudkenni") %>%
    dplyr::rename(tid = merki_id,
                  dst_id = taudkenni)
  return(d)
}

#' @title dst
#'
#' @description XXX
#'
#'
#' @param mar src_oracle tenging við oracle
fiskmerki_rafgogn <- function(mar) {

  d <- tbl_mar(mar, "fiskmerki.rafgogn") %>%
    dplyr::rename(dst_id = taudkenni)

    return(d)
}


#' @title taggart
#'
#' @description A flat dataframe of tags and recaptures
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
taggart <- function(mar) {

  stodvar <-
    lesa_stodvar(mar) %>%
    mutate(tLon = -geoconvert1(kastad_v_lengd),
           tLat =  geoconvert1(kastad_n_breidd),
           tAr = to_char(dags, 'yyyy')) %>%
    select(synis_id,
           leidangur,
           stod,
           tDags = dags,
           tAr,
           tReitur = reitur,
           tSmareitur = smareitur,
           tLon,
           tLat,
           tDypi = dypi_kastad,
           tVeidarfaeri = veidarfaeri)

  fiskar <-
    tbl_mar(mar, "fiskmerki.fiskar") %>%
    select(fiskur_id = id,
           synis_id,
           tTegund = tegund,
           tLengd = lengd,
           tThyngd = thyngd,
           tKyn = kyn,
           tKynthroski = kynthroski)

  merki <-
    tbl_mar(mar, "fiskmerki.merki") %>%
    select(tid = id,
           fiskur_id,
           audkenni,
           numer)

  d <-
    fiskar %>%
    dplyr::left_join(merki, by = "fiskur_id") %>%
    dplyr::left_join(stodvar, by = "synis_id") %>%
    dplyr::left_join(fiskmerki_endurheimtur(mar), by = "tid") %>%
    dplyr::left_join(fiskmerki_rafaudkenni(mar),  by = "tid") %>%
    select(-id, -tid)

  return(d)
}


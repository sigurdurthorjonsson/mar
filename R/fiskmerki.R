#' @title merki
#'
#' @description XXX
#'
#' @param con src_oracle tenging við oracle
#'
#' @export

fiskmerki_merki <- function(con) {
  d <- tbl_mar(con, "fiskmerki.merki") %>%
    dplyr::rename(tid = id)
  return(d)
}

#' @title fiskar
#'
#' @description XXX
#'
#' @param con src_oracle tenging við oracle
#'
#' @export
fiskmerki_fiskar <- function(con) {

  d <- tbl_mar(con, "fiskmerki.fiskar") %>%
    dplyr::rename(fiskur_id = id)

    return(d)
}

#' @title endurheimtur
#'
#' @description XXX
#'
#' @param con src_oracle tenging við oracle
#'
#' @export
fiskmerki_endurheimtur <- function(con) {
  d <- tbl_mar(con, "fiskmerki.endurheimtur") %>%
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
#' @param con src_oracle tenging við oracle
#'
#' @export
fiskmerki_rafaudkenni <- function(con) {

  d <- tbl_mar(con, "fiskmerki.rafaudkenni") %>%
    dplyr::rename(tid = merki_id,
                  dst_id = taudkenni)
  return(d)
}

#' @title dst
#'
#' @description XXX
#'
#' @param con src_oracle tenging við oracle
#' @export
fiskmerki_rafgogn <- function(con) {

  d <- tbl_mar(con, "fiskmerki.rafgogn") %>%
    dplyr::rename(dst_id = taudkenni)

    return(d)
}


#' @title taggart
#'
#' @description A flat dataframe of tags and recaptures
#'
#' @export
#'
#' @param con src_oracle tenging við oracle
taggart <- function(con) {

  stodvar <-
    lesa_stodvar(con) %>%
    mutate(tLon = kastad_v_lengd,
           tLat =  kastad_n_breidd,
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
    fiskmerki_fiskar(con) %>%
    select(fiskur_id,
           synis_id,
           tTegund = tegund,
           tLengd = lengd,
           tThyngd = thyngd,
           tKyn = kyn,
           tKynthroski = kynthroski)

  merki <-
    fiskmerki_merki(con) %>%
    select(tid,
           fiskur_id,
           audkenni,
           numer)

  d <-
    fiskar %>%
    dplyr::left_join(merki, by = "fiskur_id") %>%
    dplyr::left_join(stodvar, by = "synis_id") %>%
    dplyr::left_join(fiskmerki_endurheimtur(con), by = "tid") %>%
    dplyr::left_join(fiskmerki_rafaudkenni(con),  by = "tid") %>%
    select(-id, -tid)

  return(d)
}


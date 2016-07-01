#' @title merki
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
merki <- function(mar) {
  d <- tbl_mar(mar, "fiskmerki.merki") %>%
    dplyr::rename(tid = id)
  return(d)
}

#' @title fiskar
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
mfiskar <- function(mar) {

  d <- tbl_mar(mar, "fiskmerki.fiskar") %>%
    dplyr::rename(fiskur_id = id)

    return(d)
}

#' @title endurheimtur
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
endurheimtur <- function(mar) {
  d <- tbl_mar(mar, "fiskmerki.endurheimtur") %>%
    dplyr::rename(rid = id,
                  tid = merki_id,
                  rtegund = tegund,
                  rskip_nr = skip_nr,
                  rreitur = reitur,
                  rsmareitur = smareitur,
                  rar = ar,
                  rman = manudur,
                  rlengd = lengd,
                  rkyn = kyn,
                  rkynthroski = kynthroski,
                  rage = aldur)

  return(d)
}

#' @title rafaudkenni
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
rafaudkenni <- function(mar) {

  d <- tbl_mar(mar, "fiskmerki.rafaudkenni") %>%
    dplyr::rename(tid = merki_id,
                  dst_id = taudkenni)
  return(d)
}

#' @title dst
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
dst <- function(mar) {

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

  d <-
    merki(mar) %>%
    dplyr::left_join(mfiskar(mar),      by = "fiskur_id") %>%
    dplyr::left_join(lesa_stodvar(mar), by = "synis_id") %>%
    dplyr::left_join(endurheimtur(mar), by = "tid") %>%
    dplyr::left_join(rafaudkenni(mar),  by = "tid")

  return(d)
}


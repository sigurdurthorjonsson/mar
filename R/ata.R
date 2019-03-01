#' Ástusýni
#' @name ata
#' @param con tenging við mar
#'
#' @return fyrirspurn
#' @export
ata_hafsyni <- function(con) {
  tbl_mar(con,"ata.hafsyni") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_thurrvigt_tegund <- function(con) {
  tbl_mar(con,"ata.thurrvigt_tegund") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_rummal_thattur <- function(con) {
  tbl_mar(con,"ata.rummal_thattur") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_thurrvigt_thattur <- function(con) {
  tbl_mar(con,"ata.thurrvigt_thattur") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_talningamadur <- function(con) {
  tbl_mar(con,"ata.talningamadur") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_astand <- function(con) {
  tbl_mar(con,"ata.astand") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_votvigt <- function(con) {
  tbl_mar(con,"ata.votvigt") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_verkefni <- function(con) {
  tbl_mar(con,"ata.verkefni") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_thurrvigt <- function(con) {
  tbl_mar(con,"ata.thurrvigt") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_tegundir_hopar <- function(con) {
  tbl_mar(con,"ata.tegundir_hopar") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_talning <- function(con) {
  tbl_mar(con,"ata.talning") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_stod <- function(con) {
  tbl_mar(con,"ata.stod") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_stig <- function(con) {
  tbl_mar(con,"ata.stig") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_sofnunartaeki <- function(con) {
  tbl_mar(con,"ata.sofnunartaeki") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_snid <- function(con) {
  tbl_mar(con,"ata.snid") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_shortcut <- function(con) {
  tbl_mar(con,"ata.shortcut") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_rummal <- function(con) {
  tbl_mar(con,"ata.rummal") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_prosomlengd <- function(con) {
  tbl_mar(con,"ata.prosomlengd") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_lengdir <- function(con) {
  tbl_mar(con,"ata.lengdir") %>%
    dplyr::select(-c(sng:sbt))
}

#' @rdname ata
#' @export
ata_leidangur <- function(con) {
  tbl_mar(con,"ata.leidangur") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_kynthroski <- function(con) {
  tbl_mar(con,"ata.kynthroski") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_hopar_stig <- function(con) {
  tbl_mar(con,"ata.hopar_stig") %>%
    dplyr::select(-c(sng:sbt))
}

#' @rdname ata
#' @export
ata_hopar <- function(con) {
  tbl_mar(con,"ata.hopar") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_flurljomun <- function(con) {
  tbl_mar(con,"ata.flurljomun") %>%
    dplyr::select(-c(snt:sbg))
}

#' @rdname ata
#' @export
ata_eggjaframleidsla <- function(con) {
  tbl_mar(con,"ata.eggjaframleidsla") %>%
    dplyr::select(-c(snt:sbg))
}

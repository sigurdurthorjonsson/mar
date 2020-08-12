#' Landssvæði í veiðibókargrunni
#' @param con src_oracle tenging við oracle
veidibok_landsvaedi <- function(con) {
  tbl_mar(con, "veidibok.landsvaedi") %>%
    dplyr::select(-c(sng:sbt))
}

#' Þyngdarstuðlar veiðibókargrunnur
#' @param con src_oracle tenging við oracle
#' @description Meðalsamband lengdar og þyngdar hjá íslenskum laxi líklega $W = 0.0000215 L^2.83307$
veidibok_thyngdarstudlar <- function(con) {
  tbl_mar(con, "veidibok.thyngdarstudlar") %>%
    dplyr::select(-c(sng:sbt))
}

#'Þyngdarbil veiðibókargrunnur
#' @param con src_oracle tenging við oracle
#' @description Hjálpartafla fyrir úrvinnslu
veidibok_thyngdarbil <- function(con) {
  tbl_mar(con, "veidibok.thyngdarbil")
}

#' Notendur í veiðibókargrunni
#' @param con src_oracle tenging við oracle
#' @description Notendur í veiðibókargrunni.
veidibok_notendur_svaedi <- function(con) {
  tbl_mar(con, "veidibok.notendur_svaedi") %>%
    dplyr::select(-c(sng:sbt))
}

#' Veiðisvæði í veiðibókargrunni
#' @param con src_oracle tenging við oracle
#' @description Yfirlit yfir veiðisvæði í veiðibókargrunni.
#' @export
veidibok_veidisvaedi <- function(con) {
  tbl_mar(con, "veidibok.veidisvaedi") %>%
    dplyr::select(-c(sng:sbt))
}

#' Veiðistaðir í veiðibókargrunni
#' @param con src_oracle tenging við oracle
#' @description Upplýsingar um veiðistaði í veiðibókargruni
#' @export
veidibok_veidistadur <- function(con) {
  tbl_mar(con, "veidibok.veidistadur") %>%
    dplyr::select(-c(sng:sbt))
}

#' Veiði í veiðibókargrunni
#' @description Grunntafla fyrir veiði í veiðibókargrunni. Allar upplýsingar eru í \link{veidibok_veidibok} falli
#' @param con src_oracle tenging við oracle
veidibok_veidi <- function(con) {
  tbl_mar(con, "veidibok.veidi") %>%
    dplyr::select(-c(sng:sbt))
}

#' Veiðarfæri í veiðibókargrunni
#' @description Veiðarfæri og agn í veiðibókargrunni. Fluga, Maðkur, Annað, Net eða Óákveðið
#' @param con src_oracle tenging við oracle
veidibok_veidarfaeri <- function(con) {
  tbl_mar(con, "veidibok.veidarfaeri") %>%
    dplyr::select(-c(sng:sbt))
}

#' Vatnsföll í veiðibókargrunni
#' @description Upplýsingar um vatnsföll í veiðibókargrunni
#' @param con src_oracle tenging við oracle
#' @export
veidibok_vatnsfall <- function(con) {
  tbl_mar(con, "veidibok.vatnsfall") %>%
    dplyr::select(-c(sng:sbt))
}

#' Fisktegundir í veiðibókargrunni
#' @description Id og nöfn fyrir fisktegundir í veiðibókargrunni
#' @param con src_oracle tenging við oracle
veidibok_fisktegundir <- function(con) {
  tbl_mar(con, "veidibok.fisktegundir_v")
}

#' Lax- og silungsveiðiskráningar veiðibókargrunnur
#' @description Veitir aðgang að lax- og silungsveiðiskráningum. Einstaklingsskráningar með öllum helstu
#' upplýsingum úr öðrum töflum. Sameinað í Oracle-grunni.
#' @param con src_oracle tenging við oracle
#' @export
veidibok_veidibok <- function(con) {
  tbl_mar(con, "veidibok.veidibok_v") %>%
    dplyr::select(-c(snt:sbg)) %>%
    dplyr::mutate(ar =   to_number(to_char(dags, "YYYY")),
           man =  to_number(to_char(dags, "MM")),
           vika = to_number(to_char(dags, "WW")))
}

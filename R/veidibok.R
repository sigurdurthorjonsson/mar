
veidibok_landsvaedi <- function(mar) {
  tbl_mar(mar, "veidibok.landsvaedi") %>%
    dplyr::select(-c(sng:sbt))
}


veidibok_thyngdarstudlar <- function(mar) {
  tbl_mar(mar, "veidibok.thyngdarstudlar") %>%
    dplyr::select(-c(sng:sbt))
}

veidibok_thyngdarbil <- function(mar) {
  tbl_mar(mar, "veidibok.thyngdarbil")
}

veidibok_notendur_svaedi <- function(mar) {
  tbl_mar(mar, "veidibok.notendur_svaedi") %>%
    dplyr::select(-c(sng:sbt))
}


veidibok_veidisvaedi <- function(mar) {
  tbl_mar(mar, "veidibok.veidisvaedi") %>%
    dplyr::select(-c(sng:sbt))
}


veidibok_veidistadur <- function(mar) {
  tbl_mar(mar, "veidibok.veidistadur") %>%
    dplyr::select(-c(sng:sbt))
}

veidibok_veidi <- function(mar) {
  tbl_mar(mar, "veidibok.veidi") %>%
    dplyr::select(-c(sng:sbt))
}

veidibok_veidarfaeri <- function(mar) {
  tbl_mar(mar, "veidibok.veidarfaeri") %>%
    dplyr::select(-c(sng:sbt))
}

veidibok_vatnsfall <- function(mar) {
  tbl_mar(mar, "veidibok.vatnsfall") %>%
    dplyr::select(-c(sng:sbt))
}


veidibok_fisktegundir <- function(mar) {
  tbl_mar(mar, "veidibok.fisktegundir_v")
}


veidibok_veidibok <- function(mar) {
  tbl_mar(mar, "veidibok.veidibok_v") %>%
    dplyr::select(-c(snt:sbg)) %>%
    dplyr::mutate(ar =   to_number(to_char(dags, "YYYY")),
           man =  to_number(to_char(dags, "MM")),
           vika = to_number(to_char(dags, "WW")))
}

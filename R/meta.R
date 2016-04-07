#' lesa veiðarfæri
#'
#' @param mar db connection
#'
#' @return db query object
#' @export
#'
lesa_veidarfaeri <- function(mar){
  dplyr::tbl(mar,dplyr::sql("orri.veidarfaeri")) %>%
    select(-c(SNT:SBN)) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))
}

#' lesa tegundir
#'
#' @param mar db connection
#'
#' @return db query object
#' @export
#'
lesa_tegundir <- function(mar){
  dplyr::tbl(mar,dplyr::sql("orri.fisktegundir")) %>%
    select(-c(SNT:SBN)) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))
}

#' lesa synaflokka
#'
#' @param mar db connection
#'
#' @return db query object
#' @export
#'
lesa_synaflokka <- function(mar){
  dplyr::tbl(mar,dplyr::sql("fiskar.synaflokkar")) %>%
  dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))
}

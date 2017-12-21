#' Síritagögn
#'
#' sækir gögn úr síritum veiðarfæra
#'
#' @param mar
#'
#' @return töfluskronster
#' @export
#'
siritar_hitastig <- function(mar){
  tbl_mar(mar,'siritar.hitastig') %>%
    select(-c(sng:sbt))
}

#' @describeIn siritar_hitastig
#' @export
siritar_skjal <- function(mar){
  tbl_mar(mar,'siritar.skjal') %>%
    select(-c(sng:sbt))
}

#' @describeIn siritar_hitastig
#' @export
siritar_skjal_stod <- function(mar){
  tbl_mar(mar,'siritar.skjal_stod') %>%
    select(-c(sng:sbt))
}

#' @describeIn siritar_hitastig
#' @export
siritar_scanmar <- function(mar){
  tbl_mar(mar,'siritar.scanmar') %>%
    select(-c(sng:sbt))
}

#' @describeIn siritar_hitastig
#' @export
siritar_stadsetning <- function(mar){
  tbl_mar(mar,'siritar.stadsetning') %>%
    select(-c(sng:sbt))
}


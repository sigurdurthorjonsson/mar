#' Síritagögn
#'
#' sækir gögn úr síritum veiðarfæra
#'
#' @param con XXX
#'
#' @name siritar_hitastig
#'
#' @return töfluskronster
#' @export
#'
siritar_hitastig <- function(con){
  tbl_mar(con,'siritar.hitastig') %>%
    dplyr::select(-c(sng:sbt))
}

#' Siritar skjal
#'
#' @param con XXX
#'
#' @name siritar_skjal
#'
#' @export
siritar_skjal <- function(con){
  tbl_mar(con,'siritar.skjal') %>%
    dplyr::select(-c(sng:sbt))
}

#' Siritar skjal stöð
#'
#' @name siritar_skjal_stod
#'
#' @param con XXX
#' @export
siritar_skjal_stod <- function(con){
  tbl_mar(con,'siritar.skjal_stod') %>%
    dplyr::select(-c(sng:sbt))
}

#' siritar_scanmar
#'
#' @name siritar_scanmar
#'
#' @param con XXX
#' @export
siritar_scanmar <- function(con){
  tbl_mar(con,'siritar.scanmar') %>%
    dplyr::select(-c(sng:sbt))
}

#' siritar_stadsetning
#'
#' @name siritar_stadsetning
#'
#' @param con XXX
#' @export
siritar_stadsetning <- function(con){
  tbl_mar(con,'siritar.stadsetning') %>%
    dplyr::select(-c(sng:sbt))
}


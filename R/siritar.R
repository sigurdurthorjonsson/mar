#' Síritagögn
#'
#' sækir gögn úr síritum veiðarfæra
#'
#' @param con XXX
#'
#' @return töfluskronster
#' @export
#'
siritar_hitastig <- function(con){
  tbl_mar(con,'siritar.hitastig') %>%
    select(-c(sng:sbt))
}

#' Siritar skjal
#'
#' @param con XXX
#' @export
siritar_skjal <- function(con){
  tbl_mar(con,'siritar.skjal') %>%
    select(-c(sng:sbt))
}

#' Siritar skjal stöð
#' @param con XXX
#' @export
siritar_skjal_stod <- function(con){
  tbl_mar(con,'siritar.skjal_stod') %>%
    select(-c(sng:sbt))
}

#' siritar_scanmar
#' @param con XXX
#' @export
siritar_scanmar <- function(con){
  tbl_mar(con,'siritar.scanmar') %>%
    select(-c(sng:sbt))
}

#' siritar_stadsetning
#' @param con XXX
#' @export
siritar_stadsetning <- function(con){
  tbl_mar(con,'siritar.stadsetning') %>%
    select(-c(sng:sbt))
}


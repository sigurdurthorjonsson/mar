#' Hvalir
#'
#' @param mar
#'
#' @return tenging við hvalir_v
#' @export
#'
#' @examples
hvalir_hvalir <- function(mar){
  tbl_mar(mar,'hvalir.hvalir_v') %>%
    mar:::geoconvert(col.names=c('veiddur_breidd','veiddur_lengd'))
}


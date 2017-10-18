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
    dplyr::mutate(veiddur_breidd = to_number(replace(veiddur_breidd,',','.')),
                  veiddur_lengd = to_number(replace(veiddur_lengd,',','.'))) %>%
    dplyr::select_(.dots = colnames(tbl_mar(mar,"hvalir.hvalir_v"))) %>%
    dplyr::mutate(ar = to_char(dags_veidi,'yyyy'),
                  er_fostur = ifelse(substr(radnumer,-1,0)=='F',1,0))
}


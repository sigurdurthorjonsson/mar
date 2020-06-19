#' Hvalir
#'
#' @param con Tenging við Oracle
#'
#' @name hvalir_hvalir
#'
#' @return SQL fyrirspurn
#'
#' @export
#'
hvalir_hvalir <- function(con) {
  tbl_mar(con, 'hvalir.hvalir_v') %>%
    dplyr::mutate(veiddur_breidd = to_number(replace(nvl(veiddur_breidd,0),',','.')),
                  veiddur_lengd = to_number(replace(decode(veiddur_lengd,'-',NULL,veiddur_lengd),',','.'))) %>%
    dplyr::select_(.dots = colnames(tbl_mar(mar,"hvalir.hvalir_v"))) %>%
    dplyr::mutate(ar = to_char(dags_veidi,'yyyy'),
                  er_fostur = ifelse(substr(radnumer,-1,0)=='F',1,0))
}


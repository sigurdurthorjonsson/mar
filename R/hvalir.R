#' Hvalir
#'
#' @param mar Tenging við Oracle
#'
#' @name hvalir_hvalir
#'
#' @rdname hvalir
#' @return SQL fyrirspurn
#'
#' @export
#'
hvalir_hvalir <- function(mar) {
  tbl_mar(mar, 'hvalir.hvalir_v') %>%
    dplyr::mutate(veiddur_breidd = to_number(replace(nvl(veiddur_breidd,0),',','.')),
                  veiddur_lengd = to_number(replace(decode(veiddur_lengd,'-',NULL,veiddur_lengd),',','.'))) %>%
    dplyr::select_(.dots = colnames(tbl_mar(mar,"hvalir.hvalir_v"))) %>%
    dplyr::mutate(ar = to_char(dags_veidi,'yyyy'),
                  er_fostur = ifelse(substr(radnumer,-1,0)=='F',1,0)) %>%
    dplyr::rename(hvalur_id = id) %>%
    dplyr::left_join(hvalir_kynthroski(mar), by = c("hvalur_id", "kyn")) %>%
    dplyr::mutate(kynthroski = nvl(kynthroski,feltkynthroski))
}


#' @rdname hvalir
#' @export
hvalir_eistu <- function(mar){
  tbl_mar(mar,'hvalir.eistu') %>%
    dplyr::select(-c(sng:sbt)) %>%
    dplyr::left_join(tbl_mar(mar, 'hvalir.feltkynthroski') %>%
                       dplyr::select(kynthroski_id  = id,kynthroski=heiti),
                     by = 'kynthroski_id') %>%
    dplyr::select(-kynthroski_id) %>%
    dplyr::mutate(kyn = 'KK')
}

#' @rdname hvalir
#' @export
hvalir_eggjastokkar <- function(mar){
  tbl_mar(mar,'hvalir.eggjastokkar') %>%
    dplyr::select(-c(sng:sbt)) %>%
    dplyr::left_join(tbl_mar(mar, 'hvalir.feltkynthroski') %>%
                       dplyr::select(throski_id  = id,kynthroski=heiti),
                     by = 'throski_id') %>%
    dplyr::select(-throski_id) %>%
    dplyr::mutate(kyn = 'KK')
}

#' @rdname hvalir
#' @export
hvalir_kynthroski <- function(mar){
  hvalir_eistu(mar) %>%
    dplyr::mutate(order = substr(kynthroski,0,0)) %>%
    dplyr::group_by(hvalur_id) %>%
    dplyr::filter(order == max(order,na.rm = TRUE)) %>%
    dplyr::select(hvalur_id,kyn,kynthroski) %>%
    dplyr::union_all(
      hvalir_eggjastokkar(mar) %>%
        dplyr::mutate(order = substr(kynthroski,0,0)) %>%
        dplyr::group_by(hvalur_id) %>%
        dplyr::filter(order == max(order,na.rm = TRUE)) %>%
        dplyr::select(hvalur_id,kyn,kynthroski)
    ) %>%
    dplyr::distinct()
}


#' @rdname hvalir
#' @export
hvalir_magasyni <- function(mar){
  tbl_mar(mar,'hvalir.magasyni') %>%
    dplyr::select(-c(sng:sbt)) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.meltingarstig') %>%
                       dplyr::select(id,meltingarstig = heiti),
                     by = c('meltingarstig_id'='id')) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.sigti') %>%
                       dplyr::select(id,sigti = heiti),
                     by = c('sigti_id'='id')) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.faedutegundir') %>% ## þetta er nú meiri andsk vitleysan að búa til nýja tegunda töflu
                       dplyr::select(tegund,helsta_faeda = heiti, lat_heiti),
                     by = c('helsta_faeda_id'='tegund')) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.meltingarvegur') %>%
                       dplyr::select(id,meltingarvegur = heiti),
                     by = c('meltingarvegur_id'='id')) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.magafylli') %>%
                       dplyr::select(id,magafylli = heiti),
                     by = c('magafylli_id'='id')) %>%
    dplyr::select(-c(meltingarstig_id,sigti_id,helsta_faeda_id,meltingarvegur_id,magafylli_id)) %>%
    dplyr::mutate(hlutasyni = ifelse(nvl(hlutasyni,1) == 0, 1,nvl(hlutasyni,1)),
                  rummal_i_sigti = nvl(rummal_i_sigti,heildarrummal),
                  leidrett_vigt = heildarvigt/hlutasyni) %>%
    dplyr::rename(magasyni_id = id)
}

#' @rdname hvalir
#' @export
hvalir_magagreining <- function(mar){
  tbl_mar(mar,'hvalir.magagreining') %>%
    dplyr::select(-c(sng:sbt)) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.meltingarstig') %>%
                       dplyr::select(id,meltingarstig = heiti),
                     by = c('meltingarstig_id'='id')) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.faedutegundir') %>% ## þetta er nú meiri andsk vitleysan að búa til nýja tegunda töflu
                       dplyr::select(tegund,faedutegund = heiti, lat_heiti),
                     by = c('faedutegund_id'='tegund')) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.maelieining_magn_synis') %>%
                       dplyr::select(maelieining_id = id, maelieining = heiti),
                     by = 'maelieining_id') %>%
    dplyr::select(-c(meltingarstig_id,maelieining_id,faedutegund_id)) %>%
    dplyr::rename(magagreining_id = id) %>%
    dplyr::mutate(hlutasyni = nvl(hlutasyni,1),
                  medal_thyngd = case_when(maelieining == 'kg'~magn,
                                     maelieining == 'gr'~magn/1000,
                                     TRUE~NA)/nvl(fjoldi,1),
                  lengd = case_when(maelieining == 'mm'~10*magn,
                                    maelieining == 'cm'~magn,
                                    maelieining == 'm'~magn/100,
                                    TRUE ~ NA))
}


#' @rdname hvalir
#' @export
hvalir_faedumaeling <- function(mar){
  tbl_mar(mar,'hvalir.faedumaelingar' ) %>%
    dplyr::select(-c(sng:sbt)) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.finflokkun') %>%
                       dplyr::select(finflokkun_id = id,fjoldi),
                     by = 'finflokkun_id') %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.meltingarstig') %>%
                       dplyr::select(id,meltingarstig = heiti),
                     by = c('meltingarstig_id'='id')) %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.maelieining_magn_synis') %>%
                       dplyr::select(maelieining_id = id, maelieining = heiti),
                     by = 'maelieining_id') %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.tegund_faedumaelingar') %>%
                       dplyr::select(tegund_maelingar_id = id, tegund_maelingar = heiti),
                     by = 'tegund_maelingar_id') %>%
    dplyr::left_join(tbl_mar(mar,'hvalir.kalibrering') %>%
                       dplyr::select(kalibrering_id = id, taeki:margfoldun, hlutgler),
                     by = 'kalibrering_id') %>%
    dplyr::select(-c(finflokkun_id,meltingarstig_id,finflokkun_id,tegund_maelingar_id,kalibrering_id)) %>%
    dplyr::mutate(leidrett_gildi = gildi*decode(maelieining,'mm',margfoldun,1)) %>%
    dplyr::rename(faedumaeling_id = id)

}





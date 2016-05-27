ora_table <- function(mar,tbl){
  dplyr::tbl(mar,dplyr::sql(tbl)) %>%
    dplyr::rename_(.dots=setNames(colnames(.),tolower(colnames(.))))
}


#' Magasyni Hafrannsóknarstofnunar
#' @name faeda
#' @param mar tenging við oraclegrunn
#'
#' @return fyrirspurn
#' @export
faeda_hopar <- function(mar){
  ora_table(mar,'faeda.f_tegundir') %>%
    dplyr::left_join(lesa_tegundir(mar),by='tegund') %>%
    dplyr::select(-c(heiti,yfir_flokkur,visindaheiti)) %>%
    dplyr::mutate(enskt_heiti = ifelse(faeduhopur == 'pisces','Unid fishes',
                                       ifelse(faeduhopur == 'ammodytx','Sandeel',
                                              ifelse(faeduhopur == 'pand bor', "Northern shrimp",
                                                     ifelse(faeduhopur == "heteroso","Flat fishes",
                                                            ifelse(faeduhopur == "natantia", 'Unid shrimp',
                                                                   ifelse(faeduhopur == 'rest', 'Unid remains',
                                                                          ifelse(faeduhopur == 'euphausi', 'Krill',
                                                                                 ifelse(is.na(enskt_heiti),lat_heiti,enskt_heiti)))))))))
}

#' @rdname faeda
#' @export
faeda_ranfiskar <- function(mar){
  ora_table(mar,'faeda.f_fiskar_tmp') %>%
    dplyr::filter(flokk_id > 1 &
                    !(flokk_id %in% c(111845,111846,111847,111848,111849,111850,111851,111852,111853,
                                      111854,111860,111861,111862,111863,111864,111869,111870,111871,
                                      111938,111939,111940,111941,111942,111943,111944,111945,111946,
                                      111947,111953,111954,111955,111956,111957,111977,111978,111979))) %>%
    dplyr::anti_join(ora_table(mar,'faeda.f_fiskar') %>% select(flokk_id)) %>%
    dplyr::union_all(ora_table(mar,'faeda.f_fiskar')) %>%
    dplyr::union_all(ora_table(mar,'faeda.f_flokkar') %>%
                       dplyr::left_join(ora_table(mar,'faeda.f_lenfl'),by='len_fl') %>%
                       dplyr::mutate(lengd = (max_le + min_le)/2,
                                     kvarnanr = NA,
                                     fj_uthverfir = NA) %>%
                       dplyr::select(synis_id, flokk_id, faerslunumer, ranfiskur, lengd, fj_fmaga,
                                     fj_omelt, fj_tomra, fj_aelt, kvarnanr, fj_uthverfir))
}

#' @rdname faeda
#' @export
faeda_thyngdir <- function(mar){
  ora_table(mar,'faeda.f_hopar_tmp') %>%
    dplyr::filter(flokk_id > 1 &
                    !(flokk_id %in% c(111845,111846,111847,111848,111849,111850,111851,111852,111853,
                                      111854,111860,111861,111862,111863,111864,111869,111870,111871,
                                      111938,111939,111940,111941,111942,111943,111944,111945,111946,
                                      111947,111953,111954,111955,111956,111957,111977,111978,111979))) %>%
    dplyr::anti_join(ora_table(mar,'faeda.f_hopar') %>% select(flokk_id)) %>%
    dplyr::union_all(ora_table(mar,'faeda.f_hopar')) %>%
    dplyr::mutate(thyngd = ifelse(thyngd==-1,0.2,
                                  ifelse(thyngd<0,0,thyngd)),
                  faedutegund = faeduhopur,
                  fhopar = ifelse(faeduhopur=="ammo mar","ammodytx",
                                  ifelse(faeduhopur=="mega nor" |  faeduhopur=="thys ine","euphausi",
                                         ifelse(faeduhopur=="malvil-2", 'mall vil',
                                                faeduhopur))))
}

#' @rdname faeda
#' @export
faeda_lengdir <- function(mar){
  ora_table(mar,'faeda.f_lengdir') %>%
    left_join(ora_table(mar,'faeda.f_lenfl'),by='len_fl') %>%
    mutate(lengd = lengd/10,
           brad_kyn = ifelse(faeduhopur=='mall vil',brad_kyn + 1,
                             brad_kyn),
           lengd_rf = (max_le + min_le)/2,
           flokk_id = -1) %>%
    select(-c(len_fl,max_le,min_le)) %>%
    dplyr::union_all(ora_table(mar,'faeda.f_staerdir_tmp') %>%
                       dplyr::filter(flokk_id > 1 &
                                       !(synis_id %in% c(137113,137123,137129,241142))) %>%
                       dplyr::anti_join(ora_table(mar,'faeda.f_staerdir') %>% select(synis_id)) %>%
                       dplyr::union_all(ora_table(mar,'faeda.f_staerdir')) %>%
                       dplyr::mutate(lengd = lengd/10,
                                     brad_kyn = ifelse(faeduhopur=='mall vil',brad_kyn + 1,
                                                       brad_kyn),
                                     lengd_rf = 1*lengd_rf) %>%
                       dplyr::select(synis_id, faerslunumer, ranfiskur, faeduhopur,
                                     brad_kyn, lengd, fjoldi,  haed, lengd_rf, flokk_id))
}




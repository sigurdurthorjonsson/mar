#' Magasyni Hafrannsóknarstofnunar
#' @name faeda
#' @param mar tenging við oraclegrunn
#'
#' @return fyrirspurn
#' @export
faeda_tegundir <- function(mar){
  tbl_mar(mar,'faeda.f_tegundir') %>%
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
  tbl_mar(mar,'faeda.f_fiskar_tmp') %>%
    dplyr::filter(flokk_id > 1 &
                    !(flokk_id %in% c(111845,111846,111847,111848,111849,111850,111851,111852,111853,
                                      111854,111860,111861,111862,111863,111864,111869,111870,111871,
                                      111938,111939,111940,111941,111942,111943,111944,111945,111946,
                                      111947,111953,111954,111955,111956,111957,111977,111978,111979))) %>%
    dplyr::anti_join(tbl_mar(mar,'faeda.f_fiskar') %>% select(flokk_id)) %>%
    dplyr::union_all(tbl_mar(mar,'faeda.f_fiskar')) %>%
    dplyr::mutate(len_fl =
                    if_else(lengd < 5,0,
                            if_else(lengd <7,1,
                                    if_else(lengd <10,2,
                                            if_else(lengd <15,3,
                                                    if_else(lengd <20,4,
                                                            if_else(lengd <25,5,
                                                                    if_else(lengd <30,6,
                                                                            if_else(lengd <40,7,
                                                                                    if_else(lengd <50,8,
                                                                                            if_else(lengd <60,9,
                                                                                                    if_else(lengd <70,10,
                                                                                                            if_else(lengd <80,11,
                                                                                                                    if_else(lengd <90,12,13
                                                                                                                            ))))))))))))),
                  uppruni_ranfiskar = 'f_fiskar') %>%
    dplyr::union_all(tbl_mar(mar,'faeda.f_flokkar') %>%
                       dplyr::left_join(tbl_mar(mar,'faeda.f_lenfl'),by='len_fl') %>%
                       dplyr::mutate(lengd = (max_le + min_le)/2,
                                     kvarnanr = NA,
                                     fj_uthverfir = NA,
                                     uppruni_ranfiskar = 'f_flokkar') %>%
                       dplyr::select(synis_id, flokk_id, faerslunumer, ranfiskur, lengd, fj_fmaga,
                                     fj_omelt, fj_tomra, fj_aelt, kvarnanr, fj_uthverfir,len_fl,uppruni_ranfiskar))
}

#' @rdname faeda
#' @export
faeda_thyngdir <- function(mar){
  tbl_mar(mar,'faeda.f_hopar_tmp') %>%
    dplyr::filter(flokk_id > 1 &
                    !(flokk_id %in% c(111845,111846,111847,111848,111849,111850,111851,111852,111853,
                                      111854,111860,111861,111862,111863,111864,111869,111870,111871,
                                      111938,111939,111940,111941,111942,111943,111944,111945,111946,
                                      111947,111953,111954,111955,111956,111957,111977,111978,111979))) %>%
    dplyr::mutate(uppruni = 'f_hopar_tmp') %>%
    dplyr::anti_join(tbl_mar(mar,'faeda.f_hopar') %>%
                       dplyr::select(flokk_id)) %>%
    dplyr::union_all(tbl_mar(mar,'faeda.f_hopar') %>%
                       dplyr::mutate(uppruni = 'f_hopar')) %>%
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
  tbl_mar(mar,'faeda.f_lengdir') %>%
    dplyr::left_join(tbl_mar(mar,'faeda.f_lenfl'),by='len_fl') %>%
    dplyr::mutate(lengd = lengd/10,
           brad_kyn = ifelse(faeduhopur=='mall vil',brad_kyn + 1,
                             brad_kyn),
           lengd_rf = (max_le + min_le)/2,
           flokk_id = -1,
           uppruni = 'f_lengdir') %>%
    dplyr::select(synis_id, faerslunumer, flokk_id, ranfiskur, faeduhopur,
                  brad_kyn, lengd, fjoldi,  haed, lengd_rf,len_fl,uppruni) %>%
    dplyr::union_all(tbl_mar(mar,'faeda.f_staerdir_tmp') %>%
                       dplyr::filter(flokk_id > 1 &
                                       !(synis_id %in% c(137113,137123,137129,241142))) %>%
                       dplyr::anti_join(tbl_mar(mar,'faeda.f_staerdir') %>%
                                          dplyr::select(synis_id)) %>%
                       dplyr::union_all(tbl_mar(mar,'faeda.f_staerdir')) %>%
                       dplyr::mutate(lengd = lengd/10,
                                     brad_kyn = ifelse(faeduhopur=='mall vil',brad_kyn + 1,
                                                       brad_kyn),
                                     lengd_rf = 1*lengd_rf,
                                     len_fl = NA,
                                     uppruni = 'f_staerdir') %>%
                       dplyr::select(synis_id, faerslunumer, flokk_id, ranfiskur, faeduhopur,
                                     brad_kyn, lengd, fjoldi,  haed, lengd_rf,len_fl,uppruni)) %>%
    dplyr::mutate(brad_kynth = NA) %>%
    dplyr::union_all(tbl_mar(mar,'faeda.f_kynthroski') %>%
                       dplyr::mutate(fjoldi = 1,
                                     haed = NA,
                                     len_fl = NA,
                                     uppruni = 'f_kynthroski') %>%
                       dplyr::select(synis_id, faerslunumer, flokk_id, ranfiskur, faeduhopur,
                                     brad_kyn, lengd=brad_lengd, fjoldi,  haed, lengd_rf,len_fl,uppruni,brad_kynth)) %>%
    dplyr::mutate(len_fl =
                    if_else(lengd < 5,0,
                            if_else(lengd <7,1,
                                    if_else(lengd <10,2,
                                            if_else(lengd <15,3,
                                                    if_else(lengd <20,4,
                                                            if_else(lengd <25,5,
                                                                    if_else(lengd <30,6,
                                                                            if_else(lengd <40,7,
                                                                                    if_else(lengd <50,8,
                                                                                            if_else(lengd <60,9,
                                                                                                    if_else(lengd <70,10,
                                                                                                            if_else(lengd <80,11,
                                                                                                                    if_else(lengd <90,12,13
                                                                                                                    )))))))))))))) %>%
    dplyr::rename(uppruni_lengdar = uppruni)
}




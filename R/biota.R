#' Lengdarmaelingar
#'
#' @name bio_lengdir
#'
#' @description Fallid myndar tengingu við "view" toflu lengdir
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

bio_lengdir <- function(con) {

  d <-
    tbl_mar(con,"biota.lengdir")

  return(d)

}


#' Talningar
#'
#' @name bio_numer
#'
#' @description Fallid myndar tengingu við "view" toflu numer
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

bio_numer <- function(con) {

  d <-
    tbl_mar(con,"biota.numer")

  return(d)

}


#' Kvarnir
#'
#' @name bio_kvarnir
#'
#' @description Fallid myndar tengingu við "view" toflu kvarnir
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'

bio_kvarnir <- function(con) {

  d <-
    tbl_mar(con,"biota.kvarnir")

  return(d)

}


#' Skala með töldum
#'
#' Þetta fall skala lengdardreifingar með töldum fiskum úr ralli
#'
#' @name bio_skala_med_toldum
#'
#' @param lengdir fyrirspurn á biota.lengdir
#'
#' @return fyrirspurn með sköluðum fjölda í lengdarbili
#' @export
#'
bio_skala_med_toldum <- function(lengdir){

  ratio <-
    numer(lengdir$src) %>%
    dplyr::mutate(fj_maelt = nvl(fj_maelt,1)) %>%
    dplyr::mutate(r = ifelse(nvl(fj_talid,0)==0 ,1,
                             1 + fj_talid/ifelse(fj_maelt>0,fj_maelt,1))) %>%
    dplyr::select(synis_id, tegund, r)

  lengdir %>%
    dplyr::left_join(ratio) %>%
    dplyr::mutate(fjoldi_oskalad = fjoldi) %>%
    dplyr::mutate(fjoldi = fjoldi * r)
}


#' Skala með toglengd
#'
#' Þetta fall skala lengdardreifingar með toglengd úr ralli
#'
#' @name bio_skala_med_toglengd
#'
#' @param lengdir fyrirspurn á biota.lengdir
#'
#' @return fyrirspurn með sköluðum fjölda í lengdarbili
#' @export
bio_skala_med_toglengd <- function(st_len,
                             min_towlength = 2,
                             max_towlength = 8,
                             std_towlength = 4){
  st_len %>%
    dplyr::mutate(toglengd = dplyr::if_else(toglengd > max_towlength, max_towlength, toglengd),
                  toglengd = dplyr::if_else(toglengd < min_towlength, min_towlength, toglengd)) %>%
    dplyr::mutate(fjoldi = fjoldi * std_towlength/toglengd)
}


#' Tegundir fæðu
#'
#' @name bio_faedutegundir
#'
#' @description Fallid myndar tengingu við "view" toflu f_tegundir
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#'
#' @return SQL fyrirspurn
#' @export
#'
bio_faedutegundir <- function(con){
  tbl_mar(con,'biota.f_tegundir') %>%
    dplyr::left_join(lesa_tegundir(con),by='tegund') %>%
    dplyr::select(-c(heiti,yfir_flokkur,visindaheiti)) %>%
    dplyr::mutate(enskt_heiti = ifelse(faeduhopur == 'pisces','Unid fishes',
                                       ifelse(faeduhopur == 'ammodytx','Sandeel',
                                              ifelse(faeduhopur == 'pand bor', "Northern shrimp",
                                                     ifelse(faeduhopur == "heteroso","Flat fishes",
                                                            ifelse(faeduhopur == "natantia", 'Unid shrimp',
                                                                   ifelse(faeduhopur == 'rest', 'Unid remains',
                                                                          ifelse(faeduhopur == 'euphausi', 'Krill',
                                                                                 nvl2(enskt_heiti,enskt_heiti,lat_heiti)))))))))
}

#' Fæða ránfiskar
#'
#' @name bio_ranfiskar
#'
#' @description Fallid myndar tengingu við "view" toflu f_fiskar
#' , f_flokkar og f_lenfl í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_ranfiskar <- function(con){
  tbl_mar(con,'biota.f_fiskar') %>%
    dplyr::mutate(len_fl =
                    dplyr::if_else(lengd < 5,0,
                                   dplyr::if_else(lengd <7,1,
                                                  dplyr::if_else(lengd <10,2,
                                                                 dplyr::if_else(lengd <15,3,
                                                                                dplyr::if_else(lengd <20,4,
                                                                                               dplyr::if_else(lengd <25,5,
                                                                                                              dplyr::if_else(lengd <30,6,
                                                                                                                             dplyr::if_else(lengd <40,7,
                                                                                                                                            dplyr::if_else(lengd <50,8,
                                                                                                                                                           dplyr::if_else(lengd <60,9,
                                                                                                                                                                          dplyr::if_else(lengd <70,10,
                                                                                                                                                                                         dplyr::if_else(lengd <80,11,
                                                                                                                                                                                                        dplyr::if_else(lengd <90,12,13
                                                                                                                                                                                                        ))))))))))))),
                  uppruni_ranfiskar = 'f_fiskar') %>%
    dplyr::union_all(tbl_mar(con,'biota.f_flokkar') %>%
                       dplyr::left_join(tbl_mar(con,'biota.f_lenfl'),by='len_fl') %>%
                       dplyr::mutate(lengd = (max_le + min_le)/2,
                                     kvarnanr = NA,
                                     fj_uthverfir = NA,
                                     uppruni_ranfiskar = 'f_flokkar') %>%
                       dplyr::select(synis_id, flokk_id, faerslunumer, ranfiskur, lengd, fj_fmaga,
                                     fj_omelt, fj_tomra, fj_aelt, kvarnanr, fj_uthverfir,len_fl,uppruni_ranfiskar))
}

#' Fæða þyngdir
#'
#' @name bio_brad_tyngdir
#'
#' @description Fallid myndar tengingu við "view" toflu f_hopar
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_brad_tyngdir <- function(con){
  tbl_mar(con,'biota.f_hopar') %>%
    dplyr::mutate(uppruni = 'f_hopar') %>%
    dplyr::mutate(thyngd = ifelse(thyngd==-1,0.2,
                                  ifelse(thyngd<0,0,thyngd)),
                  faedutegund = faeduhopur,
                  fhopar = ifelse(faeduhopur=="ammo mar","ammodytx",
                                  ifelse(faeduhopur=="mega nor" |  faeduhopur=="thys ine","euphausi",
                                         ifelse(faeduhopur=="malvil-2", 'mall vil',
                                                faeduhopur))))
}


#' Fæða lengdir
#'
#' @name bio_brad_lengdir
#'
#' @description Fallid myndar tengingu við "view" toflu f_lengdir
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_brad_lengdir <- function(con){
  tbl_mar(con,'biota.f_lengdir') %>%
    dplyr::left_join(tbl_mar(con,'biota.f_lenfl'),by='len_fl') %>%
    dplyr::mutate(lengd = lengd/10,
                  brad_kyn = ifelse(faeduhopur=='mall vil',brad_kyn + 1,
                                    brad_kyn),
                  lengd_rf = (max_le + min_le)/2,
                  flokk_id = -1,
                  uppruni = 'f_lengdir') %>%
    dplyr::select(synis_id, faerslunumer, flokk_id, ranfiskur, faeduhopur,
                  brad_kyn, lengd, fjoldi,  haed, lengd_rf,len_fl,uppruni) %>%
    dplyr::mutate(brad_kynth = NA) %>%
    dplyr::union_all(tbl_mar(con,'biota.f_kynthroski') %>%
                       dplyr::mutate(fjoldi = 1,
                                     haed = NA,
                                     len_fl = NA,
                                     uppruni = 'f_kynthroski') %>%
                       dplyr::select(synis_id, faerslunumer, flokk_id, ranfiskur, faeduhopur,
                                     brad_kyn, lengd=brad_lengd, fjoldi,  haed, lengd_rf,len_fl,uppruni,brad_kynth)) %>%
    dplyr::union_all(tbl_mar(con,'biota.f_staerdir') %>%
                       dplyr::mutate(haed = NA,
                                     len_fl = NA,
                                     uppruni = 'f_staerdir',
                                     brad_kynth = NA) %>%
                       dplyr::select(synis_id, faerslunumer, flokk_id, ranfiskur, faeduhopur,
                                     brad_kyn, lengd, fjoldi,  haed, lengd_rf,len_fl,uppruni,brad_kynth)) %>%
    dplyr::mutate(len_fl =
                    dplyr::if_else(lengd < 5,0,
                                   dplyr::if_else(lengd <7,1,
                                                  dplyr::if_else(lengd <10,2,
                                                                 dplyr::if_else(lengd <15,3,
                                                                                dplyr::if_else(lengd <20,4,
                                                                                               dplyr::if_else(lengd <25,5,
                                                                                                              dplyr::if_else(lengd <30,6,
                                                                                                                             dplyr::if_else(lengd <40,7,
                                                                                                                                            dplyr::if_else(lengd <50,8,
                                                                                                                                                           dplyr::if_else(lengd <60,9,
                                                                                                                                                                          dplyr::if_else(lengd <70,10,
                                                                                                                                                                                         dplyr::if_else(lengd <80,11,
                                                                                                                                                                                                        dplyr::if_else(lengd <90,12,13
                                                                                                                                                                                                        )))))))))))))) %>%
    dplyr::rename(uppruni_lengdar = uppruni)
}


#' Linir
#'
#' @name bio_linir
#'
#' @description Fallid myndar tengingu við "view" toflu linir
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_linir <- function(con) {
  d <- tbl_mar(con, "biota.linir")
  return(d)
}


#' Sníkjudýr
#'
#' @name bio_snikjudyr
#'
#' @description Fallid myndar tengingu við "view" toflu snikjudyr
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_snikjudyr <- function(con) {
  d <- tbl_mar(con, "biota.snikjudyr")
  return(d)
}


#' Valkvarnir
#'
#' @name bio_valkvarnir
#'
#' @description Fallid myndar tengingu við "view" toflu valkvarnir
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_valkvarnir <- function(con) {
  d <- tbl_mar(con, "biota.valkvarnir")
  return(d)
}

#' Skjóða númer
#'
#' @name bio_skjoda_numer
#'
#' @description Fallid myndar tengingu við "view" toflu skjoda_numer
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_skjoda_numer <- function(con) {
  d <- tbl_mar(con, "biota.skjoda_numer")
  return(d)
}


#' Skjóða lengdir
#'
#' @name bio_skjoda_lengdir
#'
#' @description Fallid myndar tengingu við "view" toflu skjoda_lengdir
#' í biota gagnagrunninum.
#'
#' @param con src_oracle tenging við oracle
#' @export
#'
bio_skjoda_lengdir <- function(con) {
  d <- tbl_mar(con, "biota.skjoda_lengdir")
  return(d)
}


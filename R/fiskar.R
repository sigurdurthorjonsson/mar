#' Stodvarupplysingar
#'
#' @description Fallid myndar tengingu við "view" toflu v_stodvar
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_stodvar(mar))
lesa_stodvar <- function(mar) {
  ## exclusion list (duplicate synis_id in database)
  ## a bit of a hack until this is fixed in the DB
  excl.list <-
    c(133095,  57070, 133401,  37559, 112980,
      112984, 112987, 112991, 112995, 112998,
      112999, 128268, 129166, 129168, 140153,
      140155, 129370, 129170, 128765, 129098,
      119798, 128890, 129146, 128586, 128898,
      128902, 123916, 128392, 116665, 115948,
      115967)

  st <-
    tbl_mar(mar,"fiskar.stodvar") %>%
    dplyr::select(-c(snt:sbn))
  tog <-
    tbl_mar(mar,"fiskar.togstodvar")%>%
    dplyr::select(-c(snt:sbn))
  um <-
    tbl_mar(mar,"fiskar.umhverfi")%>%
    dplyr::select(-c(snt:sbn))

  st.corr <-
    tbl_mar(mar,"fiskar.leidr_stodvar") %>%
    dplyr::select(-c(snt:sbn)) %>%
    dplyr::filter(!(synis_id %in% excl.list)) %>%
    dplyr::rename(skip=skip_nr) %>%
    dplyr::rename(kastad_n_breidd = kastad_breidd) %>%
    dplyr::rename(kastad_v_lengd =  kastad_lengd) %>%
    dplyr::rename(hift_n_breidd = hift_breidd) %>%
    dplyr::rename(hift_v_lengd = hift_lengd) %>%
    dplyr::rename(veidarfaeri = veidarf) %>%
    dplyr::rename(londunarhofn = l_hofn) %>%
    dplyr::rename(fjardarreitur = fj_reitur) %>%
    dplyr::rename(yfirbordshiti = yfirb_hiti) %>%
    dplyr::mutate(tog_lengd =-1, dregid_fra = NA) %>%
    dplyr::select(-orreitur) %>%
    dplyr::filter(dags < to_date('01.01.1986','dd.mm.yyyy') & dags > to_date('1910','yyyy')) %>%
    dplyr::mutate(uppruni_stodvar = 'leidr_stodvar')

  d <-
    st %>%
    dplyr::left_join(tog, by = "synis_id") %>%
    dplyr::left_join(um, by = "synis_id") %>%
    dplyr::filter(dags > to_date('01.01.1986','dd.mm.yyyy')) %>%
    dplyr::mutate(uppruni_stodvar = 'stodvar')%>%
    dplyr::union_all(.,dplyr::select_(st.corr,.dots=colnames(.))) %>%
    dplyr::mutate(ar =   to_number(to_char(dags, "YYYY")),
                  man =  to_number(to_char(dags, "MM")),
                  kastad_v_lengd = -kastad_v_lengd,
                  hift_v_lengd = -hift_v_lengd) %>%
    dplyr::distinct() %>%
    dplyr::rename(aths_stodvar = aths) %>%
    dplyr::rename(fj_reitur=fjardarreitur) #%>%
    #fix_pos(col.names=c('kastad_n_breidd','kastad_v_lengd',
    #                    'hift_n_breidd','hift_v_lengd'))

  return(d)

}




#' Lengdarmaelingar
#'
#' @description Fallid myndar tengingu við toflu lengdir
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_lengdir(mar))
lesa_lengdir <- function(mar) {

  excl.list <-
    c(133095,  57070, 133401,  37559, 112980,
      112984, 112987, 112991, 112995, 112998,
      112999, 128268, 129166, 129168, 140153,
      140155, 129370, 129170, 128765, 129098,
      119798, 128890, 129146, 128586, 128898,
      128902, 123916, 128392, 116665, 115948,
      115967)

  st.corr <-
    tbl_mar(mar,"fiskar.leidr_stodvar") %>%
    dplyr::filter(dags < to_date('01.01.1986','dd.mm.yyyy') & dags > to_date('1910','yyyy')) %>%
    dplyr::select(synis_id)

  st <-
    tbl_mar(mar,"fiskar.stodvar") %>%
    dplyr::filter(dags > to_date('01.01.1986','dd.mm.yyyy')) %>%
    dplyr::select(synis_id)

  le.corr <-
    tbl_mar(mar,"fiskar.leidr_lengdir") %>%
    dplyr::select(-c(sbn:snt)) %>%
    dplyr::inner_join(st.corr, by = "synis_id") %>%
    dplyr::filter(!(synis_id %in% excl.list))%>%
    dplyr::mutate(uppruni_lengdir = 'leidr_lengdir')

  d <-
    tbl_mar(mar,"fiskar.lengdir") %>%
    dplyr::inner_join(st, by = "synis_id") %>%
    dplyr::select(-c(snn:sbt)) %>%
    dplyr::mutate(uppruni_lengdir = 'lengdir') %>%
    dplyr::union_all(le.corr) %>%
    dplyr::distinct()

  return(d)

}


#' Talningar
#'
#' @description Fallid myndar tengingu við toflu numer
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_numer(mar))
lesa_numer <- function(mar) {

  excl.list <-
    c(133095,  57070, 133401,  37559, 112980,
      112984, 112987, 112991, 112995, 112998,
      112999, 128268, 129166, 129168, 140153,
      140155, 129370, 129170, 128765, 129098,
      119798, 128890, 129146, 128586, 128898,
      128902, 123916, 128392, 116665, 115948,
      115967)

  st.corr <-
    tbl_mar(mar,"fiskar.leidr_stodvar") %>%
    dplyr::filter(dags < to_date('01.01.1986','dd.mm.yyyy') & dags > to_date('1910','yyyy')) %>%
    dplyr::select(synis_id)

  st <-
    tbl_mar(mar,"fiskar.stodvar") %>%
    dplyr::filter(dags > to_date('01.01.1986','dd.mm.yyyy')) %>%
    dplyr::select(synis_id)


  num.corr <-
    tbl_mar(mar,"fiskar.leidr_numer") %>%
    dplyr::select(-c(sbn:snt)) %>%
    dplyr::inner_join(st.corr, by = "synis_id") %>%
    dplyr::filter(!(synis_id %in% excl.list)) %>%
    dplyr::rename(aths_numer=aths) %>%
    dplyr::filter() %>%
    dplyr::mutate(uppruni_numer = 'leidr_numer')

  d <-
    tbl_mar(mar,"fiskar.numer") %>%
    dplyr::inner_join(st, by = "synis_id") %>%
    dplyr::rename(aths_numer = athuga) %>%
    dplyr::select(-c(sbn:snt,dplyr::starts_with('innsl'))) %>%
    dplyr::mutate(uppruni_numer = 'numer') %>%
    dplyr::union_all(.,dplyr::select_(num.corr,.dots=colnames(.))) %>%
    dplyr::distinct()


  return(d)

}


#' Kvarnir
#'
#' @description Fallid myndar tengingu við toflu kvarnir
#' í fiskar gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
#' @examples
#' mar <- dplyrOracle::src_oracle("mar")
#' dplyr::glimpse(lesa_numer(mar))
lesa_kvarnir <- function(mar) {

  excl.list <-
    c(133095,  57070, 133401,  37559, 112980,
      112984, 112987, 112991, 112995, 112998,
      112999, 128268, 129166, 129168, 140153,
      140155, 129370, 129170, 128765, 129098,
      119798, 128890, 129146, 128586, 128898,
      128902, 123916, 128392, 116665, 115948,
      115967)



  st.corr <-
    tbl_mar(mar,"fiskar.leidr_stodvar") %>%
    dplyr::filter(dags < to_date('01.01.1986','dd.mm.yyyy') & dags > to_date('1910','yyyy')) %>%
    dplyr::select(synis_id)

  st <-
    tbl_mar(mar,"fiskar.stodvar") %>%
    dplyr::filter(dags > to_date('01.01.1986','dd.mm.yyyy')) %>%
    dplyr::select(synis_id)


  oto.corr <-
    tbl_mar(mar,"fiskar.leidr_kvarnir") %>%
    dplyr::inner_join(st.corr, by = "synis_id") %>%
    dplyr::select(-c(sbn:snt)) %>%
    dplyr::filter(!(synis_id %in% excl.list)) %>%
    dplyr::mutate(uppruni_kvarnir = 'leidr_kvarnir')

  d <-
    tbl_mar(mar,"fiskar.kvarnir") %>%
    dplyr::inner_join(st, by = "synis_id") %>%
    dplyr::select(-c(sbn:snt)) %>%
    dplyr::rename(syking = sy) %>%
    dplyr::mutate(uppruni_kvarnir = 'kvarnir') %>%
    dplyr::union_all(oto.corr)  %>%
    dplyr::rename(aths_kvarnir = aths)

  return(d)

}


#' Skala með töldum
#'
#' Þetta fall skala lengdardreifingar með töldum fiskum úr ralli
#'
#' @param lengdir fyrirspurn á fiskar.lengdir
#'
#' @return fyrirspurn með sköluðum fjölda í lengdarbili
#' @export
#'
#' @examples
skala_med_toldum <- function(lengdir){

  ratio <-
    lesa_numer(lengdir$src) %>%
    dplyr::mutate(r = ifelse(fj_talid==0, 1, fj_talid / ifelse(fj_maelt == 0, 1, fj_maelt))) %>%
    dplyr::select(synis_id, tegund, r)

  lengdir %>%
    dplyr::left_join(ratio) %>%
    dplyr::mutate(fjoldi = fjoldi * r)
}






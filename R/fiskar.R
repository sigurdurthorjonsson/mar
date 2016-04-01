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
    dplyr::tbl(mar,dplyr::sql("fiskar.stodvar")) %>%
    dplyr::select(-c(SNT:SBN))
  tog <- dplyr::tbl(mar,dplyr::sql("fiskar.togstodvar"))%>%
    dplyr::select(-c(SNT:SBN))
  um <- dplyr::tbl(mar,dplyr::sql("fiskar.umhverfi"))%>%
    dplyr::select(-c(SNT:SBN))

  st.corr <-
    dplyr::tbl(mar,dplyr::sql("fiskar.leidr_stodvar")) %>%
    dplyr::select(-c(SNT:SBN)) %>%
    dplyr::filter(!(SYNIS_ID %in% excl.list)) %>%
    dplyr::rename(SKIP=SKIP_NR,
                  KASTAD_N_BREIDD = KASTAD_BREIDD,
                  KASTAD_V_LENGD =  KASTAD_LENGD,
                  HIFT_N_BREIDD = HIFT_BREIDD,
                  HIFT_V_LENGD = HIFT_LENGD,
                  VEIDARFAERI = VEIDARF,
                  LONDUNARHOFN = L_HOFN,
                  FJARDARREITUR = FJ_REITUR,
                  YFIRBORDSHITI = YFIRB_HITI) %>%
    dplyr::mutate(TOG_LENGD =-1, DREGID_FRA = NA) %>%
    dplyr::select(-ORREITUR) %>%
    dplyr::filter(DAGS < to_date('1986','yyyy') & DAGS > to_date('1910','yyyy'))

  d <-
    st %>%
    dplyr::left_join(tog, by = "SYNIS_ID") %>%
    dplyr::left_join(um, by = "SYNIS_ID") %>%
    dplyr::filter(DAGS > to_date('1986','yyyy')) %>%
    dplyr::union_all(.,dplyr::select_(st.corr,.dots=colnames(.))) %>%
    dplyr::select_(.,.dots=within(list(),
                                  for(i in colnames(.)){
                                    assign(tolower(i),i)
                                    i <- NULL
                                  })) %>%
    dplyr::mutate(ar =   to_number(to_char(dags, "YYYY")),
                  man =  to_number(to_char(dags, "MM"))) %>%
    distinct()

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
    dplyr::tbl(mar,dplyr::sql("fiskar.leidr_stodvar")) %>%
    dplyr::filter(DAGS < to_date('1986','yyyy') & DAGS > to_date('1910','yyyy')) %>%
    dplyr::select(SYNIS_ID)

  st <-
    dplyr::tbl(mar,dplyr::sql("fiskar.stodvar")) %>%
    dplyr::filter(DAGS > to_date('1986','yyyy')) %>%
    dplyr::select(SYNIS_ID)

  le.corr <-
    dplyr::tbl(mar,dplyr::sql("fiskar.leidr_lengdir")) %>%
    dplyr::select(-c(SBN:SNT)) %>%
    dplyr::inner_join(st.corr) %>%
    dplyr::filter(!(SYNIS_ID %in% excl.list))

  d <-
    dplyr::tbl(mar,dplyr::sql("fiskar.lengdir")) %>%
    dplyr::inner_join(st) %>%
    dplyr::select(-c(SNN:SBT)) %>%
    dplyr::union_all(le.corr) %>%
    dplyr::select_(.,.dots=within(list(),
                                  for(i in colnames(.)){
                                    assign(tolower(i),i)
                                    i <- NULL
                                  })) %>%
    distinct()

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
    dplyr::tbl(mar,dplyr::sql("fiskar.leidr_stodvar")) %>%
    dplyr::filter(DAGS < to_date('1986','yyyy') & DAGS > to_date('1910','yyyy')) %>%
    dplyr::select(SYNIS_ID)

  st <-
    dplyr::tbl(mar,dplyr::sql("fiskar.stodvar")) %>%
    dplyr::filter(DAGS > to_date('1986','yyyy')) %>%
    dplyr::select(SYNIS_ID)


  num.corr <-
    dplyr::tbl(mar,dplyr::sql("fiskar.leidr_numer")) %>%
    dplyr::select(-c(SBN:SNT)) %>%
    dplyr::inner_join(st.corr) %>%
    dplyr::filter(!(SYNIS_ID %in% excl.list)) %>%
    dplyr::rename(ATHUGA=ATHS) %>%
    dplyr::filter()

  d <-
    dplyr::tbl(mar,dplyr::sql("fiskar.numer")) %>%
    dplyr::inner_join(st) %>%
    dplyr::select(-c(SBN:SNT,dplyr::starts_with('INNSL'))) %>%
    dplyr::union_all(.,dplyr::select_(num.corr,.dots=colnames(.))) %>%
    dplyr::select_(.,.dots=within(list(),
                                  for(i in colnames(.)){
                                    assign(tolower(i),i)
                                    i <- NULL
                                  })) %>%
    distinct()
  # below returns an error
    #dplyr::mutate(r = 1 + fj.talid/fj.maelt)

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
    dplyr::tbl(mar,dplyr::sql("fiskar.leidr_stodvar")) %>%
    dplyr::filter(DAGS < to_date('1986','yyyy') & DAGS > to_date('1910','yyyy')) %>%
    dplyr::select(SYNIS_ID)

  st <-
    dplyr::tbl(mar,dplyr::sql("fiskar.stodvar")) %>%
    dplyr::filter(DAGS > to_date('1986','yyyy')) %>%
    dplyr::select(SYNIS_ID)


  oto.corr <-
    dplyr::tbl(mar,dplyr::sql("fiskar.leidr_kvarnir")) %>%
    dplyr::inner_join(st.corr) %>%
    dplyr::select(-c(SBN:SNT)) %>%
    dplyr::filter(!(SYNIS_ID %in% excl.list))

  d <-
    dplyr::tbl(mar,dplyr::sql("fiskar.kvarnir")) %>%
    dplyr::inner_join(st) %>%
    dplyr::select(-c(SBN:SNT)) %>%
    dplyr::union_all(oto.corr) %>%
    dplyr::select_(.,.dots=within(list(),
                                  for(i in colnames(.)){
                                    assign(tolower(i),i)
                                    i <- NULL
                                  })) #%>%
  # below returns an error
  #dplyr::mutate(r = 1 + fj.talid/fj.maelt)

  return(d)

}







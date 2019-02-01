#' @title Landadur afli
#'
#' @description XXX
#'
#' @name lods_oslaegt
#'
#' @param mar src_oracle tenging við oracle
#' @export
lods_oslaegt <- function(mar) {

  d <- tbl_mar(mar, "kvoti.lods_oslaegt") %>%
    dplyr::rename(veidarfaeri = veidarf) %>%
    dplyr::mutate(ar =   to_number(to_char(l_dags, "YYYY")),
                  man =  to_number(to_char(l_dags, "MM")),
                  timabil = if_else(to_number(to_char(l_dags, "MM")) < 9,
                                    concat(to_number(to_char(l_dags, "YYYY")) -1, to_number(to_char(l_dags, "YYYY"))),
                                    concat(to_number(to_char(l_dags, "YYYY")), to_number(to_char(l_dags, "YYYY")) + 1)),
                  magn_oslaegt = if_else(fteg %in% c(30, 31, 34) & to_number(to_char(l_dags, "YYYY")) > 1992,
                                         magn_oslaegt * 1000,
                                         magn_oslaegt))

    return(d)

}




#' @title Landadur afli
#'
#' @description Landaður afli. Dálkurinn flokkur vísar til skipaflokks,
#' ef neikvæður þá er um erlent skip að ræða. Erlend skip eru
#' einnig þegar þetta er skrifað (1. apríl 2016) með númer frá 3815:4999.
#'
#' @name landadur_afli
#'
#' @param mar src_oracle tenging við oracle
#' @export
landadur_afli <- function(mar) {

  d <-
    lods_oslaegt(mar) %>%
#   dplyr::mutate(skip_nr = to_number(skip_nr),
#                  hofn = to_number(hofn),
#                  fteg = to_number(fteg),
#                  stada = to_number(stada),
#                  ar = to_number(ar),
#                  man = to_number(man))
    dplyr::left_join(lesa_skipaskra(mar) %>%
                       dplyr::select(skip_nr, flokkur),
                     by = "skip_nr")

  return(d)

}


#' Gamall afli (fyrir 94)
#'
#' Afli skráður af Fiskifélaginu
#'
#' @name fiskifelag_oslaegt
#'
#' @param mar tenging við mar
#'
#' @return aflatölur eftir höfn, skipi, veiðarfærði, árum og mánuðum
#' @export
fiskifelag_oslaegt <- function(mar){
  tbl_mar(mar,'fiskifelagid.landed_catch_pre94') %>%
    dplyr::mutate(komunr = -1,
                  l_dags = to_date(concat(ar,concat('.',man)),'yyyy.mm'),
                  gerd = '',
                  kfteg = to_number(-1),
                  stada = to_number(-1),
                  flokkur = to_number(-1),
                  skip_nr = to_number(skip_nr),
                  timabil = to_char(ar)) %>%
    dplyr::select(skip_nr,
                  hofn,
                  komunr,
                  l_dags,
                  gerd,
                  fteg,
                  kfteg,
                  magn_oslaegt,
                  veidisvaedi,
                  stada,
                  veidarfaeri,
                  ar,   man,  flokkur,timabil)

}

#' @title Landaður afli (Lóðs)
#'
#' @description Landaður afli byggður á töflu sem Sigfús Jó stjórnar
#'
#' @name afli_tac
#'
#' @param mar src_oracle tenging við oracle
#'
afli_tac <- function(mar) {

  d <- tbl_mar(mar, "kvoti.afli_tac") %>%
    dplyr::mutate(ar = to_number(ar),
                  man = to_number(man)) %>%
    dplyr::rename(tegund = fteg,
           veidarfaeri = veidarf)

  return(d)

}


#' @title kvoti studlar
#'
#' @description XXX
#'
#' @name kvoti_studlar
#'
#' @param mar src_oracle tenging við oracle
kvoti_studlar <- function(mar) {

  d <- tbl_mar(mar, "kvoti.studlar")

  return(d)

}

#' @title Kvóti staða
#'
#' @description XXX
#'
#' @name kvoti_stada
#'
#' @param mar src_oracle tenging við oracle
kvoti_stada <- function(mar) {

  d <-
    tbl_mar(mar, "kvoti.kv_stada") %>%
    dplyr::select(-c(sng:snt))

  return(d)

}


#' @title Kvóti staða summary
#'
#' @description Á síðari árum er þetta nokk svona:
#' kvoti = varanlegt + jofnsj + m_ara
#' stada = kvoti - afli
#' eftir = stada - tilf
#' eftir + upptaka = n_ar + onotad
#'
#' @name kvoti_stada_summarised
#'
#' @param mar src_oracle tenging við oracle
kvoti_stada_summarised <- function(mar) {

  d <-
    kvoti_stada(mar) %>%
    ## sleppum millifærslum í skiptipott v. skerðinga (skip -11),
    ## þetta virðast vera innri færslur
    dplyr::filter(skip_nr!=-11) %>%
    dplyr::left_join(kvoti_studlar(mar) %>%
                       dplyr::select(fteg = ftegund, timabil, i_oslaegt),
                     by = c("fteg", "timabil")) %>%
    dplyr::group_by(fteg, timabil) %>%
    dplyr::summarise(varanlegt = round(sum(varanlegt * i_oslaegt)/1000,0),
              jofnsj = round(sum(jofnsj * i_oslaegt)/1000,0),
              m_ara = round(sum(m_ara * i_oslaegt)/1000,0),
              kvoti = round(sum(kvoti * i_oslaegt)/1000,0),
              afli = round(sum(afli * i_oslaegt)/1000,0),
              stada = round(sum(stada * i_oslaegt)/1000,0),
              tilf = round(sum(tilf * i_oslaegt)/1000,0),
              eftir = round(sum(eftir * i_oslaegt)/1000,0),
              upptaka = round(sum(upptaka * i_oslaegt)/1000,0),
              n_ar = round(sum(n_ar * i_oslaegt)/1000,0),
              onotad = round(sum(onotad * i_oslaegt)/1000,0),
              m_skipa = round(sum(m_skipa * i_oslaegt)/1000,0))

  return(d)

}


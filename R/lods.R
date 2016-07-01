#' @title Landadur afli
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
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

#' @title Skipasaga
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
lods_skipasaga <- function(mar) {

    d <- tbl_mar(mar, "kvoti.skipasaga") %>%
      dplyr::select(-(snt:sbn))

  return(d)

}

#' @title Skipaskra
#'
#' @description XXX
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
skipaskra <- function(mar) {

  d <- tbl_mar(mar, "orri.skipaskra")

  return(d)

}

#' @title Landadur afli
#'
#' @description Landaður afli. Dálkurinn flokkur vísar til skipaflokks,
#' ef neikvæður þá er um erlent skip að ræða. Erlend skip eru
#' einnig þegar þetta er skrifað (1. apríl 2016) með númer frá 3815:4999.
#'
#' @export
#'
#' @param mar src_oracle tenging við oracle
landadur_afli <- function(mar) {

  d <-
    lods_oslaegt(mar) %>%
    dplyr::left_join(skipaskra(mar) %>%
                       dplyr::select(skip_nr, flokkur),
                     by = "skip_nr")

  return(d)

}


#' @title Landaður afli (Lóðs)
#'
#' @description Landaður afli byggður á töflu sem Sigfús Jó stjórnar
#'
#' @export
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
#' @export
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
#' @export
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
#' @export
#'
#' @param mar src_oracle tenging við oracle
kvoti_stada_summarised <- function(mar) {

  d <-
    kvoti_stada(mar) %>%
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


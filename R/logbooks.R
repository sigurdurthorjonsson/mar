#' afli.stofn
#'
#' @description Fallid myndar tengingu við toflu stofn í
#' afli gagnagrunninum. Grásleppan er alveg sér á parti ennþá
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export

afli_stofn <- function(mar) {

  tmp_func <- function(data){
    txt <- setdiff(colnames(stofn),colnames(data))
    tmp <- rep('NA_real_',length(txt))
    dplyr::mutate_(data,.dots = setNames(tmp,txt)) %>%
      dplyr::select_(.dots = colnames(stofn))
  }

  stofn <-
    tbl_mar(mar, "afli.stofn") %>%
    dplyr::mutate(uppruni_stofn = 'afli.stofn')

  smuga <-
    tbl_mar(mar,'afli.smuga_stofn') %>%
    dplyr::mutate(visir = visir+1e9,
                  uppruni_stofn = 'afli.smuga_stofn',
                  aths_texti = '') %>%
    tmp_func()

  inn <-
    tbl_mar(mar,'afli.inn_stofn') %>%
    dplyr::mutate(visir = visir+2e9,
                  uppruni_stofn = 'afli.inn_stofn',
                  aths_texti = '') %>%
    tmp_func()

  flem <-
    tbl_mar(mar,'afli.flem_stofn') %>%
    dplyr::mutate(visir = visir+3e9,
                  uppruni_stofn = 'afli.flem_stofn',
                  aths_texti = '') %>%
    tmp_func()

  plog <-
    tbl_mar(mar,'afli.plog_stofn') %>%
    dplyr::mutate(visir = visir+4e9,
                  uppruni_stofn = 'afli.plog_stofn',
                  aths_texti = '') %>%
    tmp_func()

  stofn %>%
    dplyr::union_all(smuga) %>%
    dplyr::union_all(inn) %>%
    dplyr::union_all(plog) %>%
    dplyr::union_all(inn) %>%
    dplyr::mutate(ar =   to_number(to_char(vedags, "YYYY")),
                  man =  to_number(to_char(vedags, "MM")),
                  lengd = -lengd*100,
                  breidd = breidd*100,
                  lengd_lok = -lengd_lok*100,
                  breidd_lok = breidd_lok*100) %>%
    fix_pos(col.names=c('lengd','breidd'),lon='lengd',lat='breidd')


  # ## grásleppan er alveg sér
   # grasl <-
   #   tbl_mar(mar,'afli.g_stofn') %>%
   #   dplyr::mutate(vear = vear + 1900,
   #                 stadur = NA,
   #                 bokst_regl = NA,
   #                 ahofn = NA) %>%
   #   dplyr::union_all(tbl_mar(mar,'afli.grasl_stofn'))
}

#' afli.afli
#'
#' @description Fallid myndar tengingu við toflu afli í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_afli <- function(mar) {
  tbl_mar(mar,"afli.plog_afli") %>%
    dplyr::mutate(visir = 4e9+visir,
                  uppruni_afli = 'plog_afli') %>%
    dplyr::union_all(tbl_mar(mar,"afli.inn_afli",
                             uppruni_afli = 'inn_afli') %>%
                       dplyr::mutate(visir = visir + 2e9)) %>%
    dplyr::union_all(tbl_mar(mar,"afli.smuga_afli",
                             uppruni_afli = 'smuga_afli') %>%
                       dplyr::mutate(visir = visir + 1e9)) %>%
    dplyr::union_all(tbl_mar(mar,"afli.flem_afli",
                             uppruni_afli = 'flem_afli') %>%
                       dplyr::mutate(visir = visir + 3e9)) %>%
    dplyr::mutate(medalthyngd_gr=NA,
                  astand=NA,
                  magn=NA) %>%
    dplyr::union_all(tbl_mar(mar,"afli.afli") %>%
                       dplyr::mutate(uppruni_afli = 'afli'))
}

#' afli.sjálfvirkir_maelar
#'
#' @description Fallid myndar tengingu við toflu sjálfvirkir_maelar í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
afli_sjalfvirkir_maelar <- function(mar) {

  d <- tbl_mar(mar, "afli.sjalfvirkir_maelar") %>%
    dplyr::mutate(ar =   to_number(to_char(timi, "YYYY")),
                  man =  to_number(to_char(timi, "MM")),
                  hnattstada_siriti = sign(lengd)) %>%
    dplyr::left_join(afli_stofn(mar) %>%
                       dplyr::mutate(hnattstada_stofn = -sign(lengd)) %>%
                       dplyr::select(visir, veidarfaeri, hnattstada_stofn),
              by = "visir") %>%
    # if hnattstada_stofn is undefined, visir is not found in stofn
    #   this should not really be possible
    dplyr::mutate(hnattstada_stofn = ifelse(is.na(hnattstada_stofn), 1, hnattstada_stofn),
           lengd = lengd * hnattstada_stofn * hnattstada_siriti)

  return(d)

}

#' afli.toga
#'
#' @description Fallid myndar tengingu við toflu toga í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_toga <- function(mar) {

  tmp_func <- function(data){
    txt <- setdiff(colnames(tog),colnames(data))
    tmp <- rep('NA_real_',length(txt))
    dplyr::mutate_(data,.dots = setNames(tmp,txt)) %>%
      dplyr::select_(.dots = colnames(tog))
  }

  tog <-
    tbl_mar(mar,"afli.toga") %>%
    dplyr::mutate(uppruni_toga = 'afli.toga')

  tog %>%
    dplyr::union_all(tbl_mar(mar,"afli.inn_toga") %>%
                     dplyr::mutate(visir = visir + 2e9,
                                   uppruni_toga = 'afli.inn_toga') %>%
                       tmp_func()) %>%
    dplyr::union_all(tbl_mar(mar,"afli.plog_toga") %>%
                       dplyr::mutate(visir = 4e9+visir,
                                     uppruni_toga = 'afli.plog_toga') %>%
                       tmp_func()) %>%
    dplyr::union_all(tbl_mar(mar,"afli.smuga_toga") %>%
                       dplyr::mutate(visir = visir + 1e9,
                                     uppruni_toga = 'afli.smuga_toga') %>%
                       tmp_func()) %>%
    dplyr::union_all(tbl_mar(mar,"afli.flem_toga") %>%
                       dplyr::mutate(visir = 3e9+visir,
                                     uppruni_toga = 'afli.flem_toga') %>%
                       tmp_func())
}

#' afli.lineha
#'
#' @description Fallid myndar tengingu við toflu linea í
#' afli gagnagrunninum.
#'
#' @param mar src_oracle tenging við oracle
#'
#' @return dataframe
#' @export
#'
afli_lineha <- function(mar) {

  tmp_func <- function(data){
    txt <- setdiff(colnames(tog),colnames(data))
    tmp <- rep('NA_real_',length(txt))
    dplyr::mutate_(data,.dots = setNames(tmp,txt)) %>%
      dplyr::select_(.dots = colnames(tog))
  }

  tog <-
    tbl_mar(mar,"afli.lineha") %>%
    dplyr::mutate(uppruni_lina = 'afli.lineha')

  tog %>%
    dplyr::union_all(tbl_mar(mar,"afli.smuga_lina") %>%
                       dplyr::mutate(visir = visir + 1e9,
                                     uppruni_toga = 'afli.smuga_toga') %>%
                       tmp_func())
}


#' Grásleppunet
#'
#' @param mar
#'
#' @return
#' @export
#'
#' @examples
afli_grasl <- function(mar){
  grasl <-
    tbl_mar(mar,'afli.grasl_sokn') %>%
    dplyr::mutate(sr = round(reitur/10,0),
                  uppruni_grasl = 'grasl_sokn') %>%
    dplyr::select(-vear)

  g <-
    tbl_mar(mar,'afli.g_sokn') %>%
    dplyr::mutate(sr = reitur,
           reitur = 10*reitur,
           uppruni_grasl = 'g_sokn',
           athugasemd = '') %>%
    dplyr::select_(.dots = colnames(grasl))

  dplyr::union_all(grasl,g) %>%
    sr2d() %>%
    dplyr::select(-sr) %>%
    dplyr::mutate(ar=to_char(vedags,'YYYY'),
                  man=to_char(vedags,'MM'))
  }

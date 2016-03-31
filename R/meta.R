lesa_veidarfaeri <- function(mar){
  dplyr::tbl(mar,dplyr::sql("orri.veidarfaeri")) %>%
    dplyr::select(veidarf = VEIDARFAERI,
                  fi.veidarf = FI_VEIDARFAERI,
                  lysing = LYSING,
                  lysing.enska = LYSING_ENSKA,
                  lods.veidarf = LODS_VEIDARFAERI)
}

lesa_tegundir <- function(mar){
  dplyr::tbl(mar,dplyr::sql("orri.fisktegundir")) %>%
    dplyr::select(tegund = TEGUND,
                  heiti = HEITI,
                  enskt.heiti = ENSKT_HEITI,
                  yfirflokkur = YFIR_FLOKKUR,
                  visindaheiti = VISINDAHEITI)
}

lesa_synaflokka <- function(mar){
  dplyr::tbl(mar,dplyr::sql("orri.veidarfaeri")) %>%
    dplyr::select(synaflokkur = VEIDARFAERI,
                  fi.veidarf = FI_VEIDARFAERI,
                  lysing = LYSING,
                  lysing.enska = LYSING_ENSKA,
                  lods.veidarf = LODS_VEIDARFAERI)
}

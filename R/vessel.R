vessel_registry <- function(con, standardize = TRUE) {
  q <-
    tbl_mar(con, "kvoti.skipaskra_siglo")
  if( standardize ) {
    q <-
      q %>%
      dplyr::select(vid = skipnr,
                    name = nafnskips,
                    umdnr,
                    cs = kallmerki,
                    imo = imonr,
                    homeharbour = heimahofn,
                    propeller_diameter = thvermskrufu,
                    engine_kw = vel_kw,
                    power_index = aflvisir,
                    length_registered = skradlengd,
                    width = skradbreidd,
                    depth = skraddypt,
                    length = mestalengd,
                    brl = bruttoruml,    # neet a proper acronym
                    grt = bruttotonn) %>%
      # the "claimed" kw unit is likely wrong, corrected here
      #   the original unit seems to be strange, normally have w or kw, here
      #   it seems to be deciwatts
      dplyr::mutate(name = str_trim(name),
                    umdnr = str_trim(umdnr),
                    cs = str_trim(cs),
                    cs = ifelse(cs == "", NA_character_, cs),
                    engine_kw = engine_kw / 100,
                    # units of cm to meters
                    length_registered = length_registered / 100,
                    length = length / 100,
                    width = width / 100,
                    depth = depth / 100,
                    brl = brl / 100,
                    grt = grt / 100,
                    homeharbour = str_trim(homeharbour)) %>%
      # not really used
      #separate(umdnr, c("ich", "inu"), sep = 2, convert = TRUE) %>%
      # "correct" brl for Ásgrímur Halldórsson
      dplyr::mutate(brl = ifelse(vid == 2780, 1000, brl)) %>%
      # "correct" variable for the ghost-ship,
      dplyr::mutate(length = ifelse(vid == 9928, 5, length),
                    brl = ifelse(vid == 9928, 2, brl),
                    grt = ifelse(vid == 9928, 2, grt)) %>%
      # Blífari has abnormal engine_kw, divied by 100
      dplyr::mutate(engine_kw = ifelse(vid == 2069, engine_kw / 100, engine_kw)) %>%
      # now for some metier stuff
      dplyr::mutate(vessel_length_class = dplyr::case_when(length < 8 ~ "<8",
                                                           length >= 8  & length < 10 ~ "08-10",
                                                           length >= 10 & length < 12 ~ "10-12",
                                                           length >= 12 & length < 15 ~ "12-15",
                                                           length >= 15 ~ ">=15",
                                                           TRUE ~ NA_character_))
  }

  return(q)

}


# pth <- "https://www.pfs.is/library/Skrar/Tidnir-og-taekni/Numeramal/MMSI/NUMER%20Query270619.xlsx"
# download.file(pth, destfile = "data-raw/ss-270619_mmsi.xlsx")
# v_mmsi <-
#   readxl::read_excel("data-raw/ss-270619_mmsi.xlsx") %>%
#   janitor::clean_names() %>%
#   dplyr::select(SKNR = sknr,
#                 NAME = skip,
#                 CS = kallm,
#                 MMSI = mmsi_nr,
#                 STDC = standard_c) %>%
#   dplyr::mutate(VID = case_when(str_sub(MMSI, 1, 3) == "251" ~ as.integer(SKNR),
#                                 TRUE ~ NA_integer_),
#                 VID2 = case_when(str_sub(MMSI, 1, 3) != "251" ~ as.integer(SKNR),
#                                  TRUE ~ NA_integer_)) %>%
#   dplyr::select(SKNR, VID, VID2, NAME, MMSI, CS) %>%
#   dplyr::arrange(VID)
# dbWriteTable(con, name = "VESSEL_MMSI_20190627", value = v_mmsi, overwrite = TRUE)


vessel_mmsi <- function(con) {
  tbl_mar(con, "ops$einarhj.VESSEL_MMSI_20190627")
}

vessel_mapdeck <- function(con, mid) {

  stk_trail(con) %>%
    dplyr::filter(mobileid %in% mid) %>%
    dplyr::collect(n = Inf) %>%
    dplyr::mutate(speed = ifelse(speed > 10, 10, speed)) %>%
    mapdeck::mapdeck() %>%
    mapdeck::add_scatterplot(lon = "lon",
                             lat = "lat",
                             fill_colour = "speed",
                             layer_id = "track",
                             palette = "inferno")

}

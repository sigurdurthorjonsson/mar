lb_base <- function(con, standardize = TRUE) {

  q <-
    afli_stofn(con)

  if(standardize) {
    q <-
      q %>%
      select(visir,
             vid = skipnr,
             gid = veidarf,
             year = ar,
             month = man,
             date = vedags,
             lat1 = breidd,
             lon1 = lengd,
             lat2 = breidd_lok,
             lon2 = lengd_lok,
             sq = reitur,        # Local statistical rectange (same resolution as ICES)
             ssq = smareitur,    # The quarter within a rectangle. NOTE: It is derived if NA
             z1 = dypi,          # depth
             z2 = dypi_lok,
             winddirection = vindatt,
             beaufort = vindstig,
             m_sec = m_sek,       # Meters per second??
             distance = toglengd, # Derived measure
             datel = ldags,       # Landing date
             hidl = lhofn)        # Harbour id landings took place
  }

  return(q)
}


lb_mobile <- function(con, standaridize = TRUE) {

  q <-
    tbl_mar(con, "afli.toga")

  if(standaridize) {
    q <-
      q %>%
      select(visir,
             on.bottom = ibotni,     # of the form (h)hmm
             towtime = togtimi,      # in minutes
             tempb1 = botnhiti,      # bottom temperature
             headline = hoflina,
             mesh = moskvi,
             moskvi_minnsti,
             doors.kg = hlerar,
             sweeps = grandarar,
             plow.width = pl_breidd,
             tempb2 = botnhiti_lok,
             temps1 = uppsj_hiti,         # surface temperature
             temps2 = uppsj_hiti_lok) %>%
      # get date of fishing (note: may also need gid)
      left_join(tbl_mar(con, "afli.stofn") %>% select(visir, date = vedags),
                by = "visir") %>%
      # get rid of any gear not supposed to be in the "mobile" details
      # filter(gid > 3) %>%
      # ------------------------------------------------------------------------
    # NOTE: SHOULD KEEP THIS SOMEWHERE IN THE PIPE
    #mutate(towtime = ifelse(towtime / 60 > 12, 12 * 60, towtime)) %>%
    # ------------------------------------------------------------------------
    # drop diver and blue mussel lines
    #filter(!gid %in% c(41, 42)) %>%
    mutate(l = length(on.bottom),
           t1 = case_when(l == 1 ~ paste0("00:0", on.bottom),
                          l == 2 ~ paste0("00:", on.bottom),
                          l == 3 ~ paste0("0", str_sub(on.bottom, 1, 1), ":", str_sub(on.bottom, 2, 3)),
                          l == 4 ~ paste0(str_sub(on.bottom, 1, 2), ":", str_sub(on.bottom, 3, 4)),
                          TRUE ~ NA_character_),
           t1 = (paste0(to_char(date, 'YYYY-MM-DD'), " ", t1, ":00"))) %>%
      select(-c(l, date))
    #mutate(on.bottom = str_pad(on.bottom, 4, "left", pad = "0"),
    #       on.bottom = paste0(str_sub(on.bottom, 1, 2),
    #                          ":",
    #                          str_sub(on.bottom, 3, 4)),
    #       t1 = ymd_hm(paste(as.character(date), on.bottom)),
    # ------------------------------------------------------------------------
    # NOTE: NEED TO IMPLEMENT THIS IN SQL
    #       t2 = t1 + minutes(towtime))


  }

  return(q)

}

ln_catch <- function(con) {

  landadur_afli(con) %>%
    dplyr::rename(vid = skip_nr,
                  hid = hofn,
                  ID = komunr,
                  date = l_dags,
                  sid = fteg,
                  catch = magn_oslaegt,
                  area = veidisvaedi,
                  gid = veidarfaeri,
                  year = ar,
                  month = man,
                  qyear = timabil)

}

# space for hafvog

hv_stodvar <- function(con) {
  tbl_mar(con, "hafvog.stodvar")
}

hv_skraning <- function(con) {
  tbl_mar(con, "hafvog.skraning")
}

hv_pred <- function(con) {
  hv_skraning(con) %>%
    dplyr::filter(!is.na(magaastand)) %>%
    dplyr::select(synis_id,
           pred = tegund,
           nr,
           oslaegt,
           slaegt,
           astand = magaastand) %>%
    dplyr::left_join(tbl_mar(con, "hafvog.magaastand") %>%
                       dplyr::select(astand, lysing_astands)) %>%
    dplyr::select(-astand) %>%
    dplyr::rename(astand = lysing_astands)
}


hv_prey <- function(con) {
  prey <-
    hv_skraning(con) %>%
    dplyr::filter(maeliadgerd %in% c(20, 21)) %>%
    dplyr::rename(prey = tegund,
           pred = ranfiskurteg,
           pnr = nr,
           nr = kvarnanr) %>%
    dplyr::left_join(lesa_tegundir(con) %>%
                       dplyr::select(prey = tegund, heiti)) %>%
    dplyr::select(synis_id,
           pred,
           nr,
           prey,
           heiti,
           pnr,
           n = fjoldi,
           lengd,
           kyn,
           thyngd = heildarthyngd)
  return(prey)
}

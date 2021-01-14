# library(tidyverse)
# library(mar)
# con <- connect_mar()
# gid.in.logbooks <-
#   afli_stofn(con) %>%
#   select(gid = veidarf) %>%
#   distinct() %>%
#   filter(!is.na(gid)) %>%
#   collect(n = Inf) %>%
#   mutate(in.logbooks = TRUE) %>%
#   arrange(gid)
# gid.in.stodvar <-
#   lesa_stodvar(con) %>%
#   select(gid = veidarfaeri) %>%
#   distinct() %>%
#   filter(!is.na(gid)) %>%
#   collect(n = Inf) %>%
#   mutate(in.stodvar = TRUE)
# gids <-
#   full_join(gid.in.logbooks, gid.in.stodvar) %>%
#   arrange(gid) %>%
#   full_join(husky::gearlist %>%
#               rename(gid = veidarfaeri) %>%
#               mutate(in.husky = TRUE))
#
#
# Gear <-
#   lesa_veidarfaeri(con) %>%
#   rename(gid = veidarfaeri,
#          description = lysing_enska) %>%
#   collect(n = Inf) %>%
#   arrange(gid) %>%
#   full_join(gids) %>%
#   select(gid, gclass = gear, lysing, description, everything())
#
#
# Gear <-
#   Gear %>%
#   # Note: Need to check if 8 (spærlingsvarpa) should be classed as bottom trawl
#   mutate(gclass = ifelse(gid %in% c(16, 36), 1, gclass),                    # long line
#          gclass = ifelse(gid %in% c(2, 11, 25, 29, 32, 72,90,91,92), 2, gclass),   # net
#          gclass = ifelse(gid %in% c(4, 10, 12, 56, 57), 4, gclass),             # seine
#          gclass = ifelse(gid %in% c(5, 26, 27), 5, gclass),                     # scotish seine
#          gclass = ifelse(gid %in% c(22, 31, 58, 66, 68, 69, 73, 74, 76, 77, 78, 139), 6, gclass), # botnvarpa
#          gclass = ifelse(gid %in% c(7,8, 13, 19, 21, 23, 24, 33, 34, 44), 7, gclass),                  # flotvarpa
#          gclass = ifelse(gid == 46, 8, gclass),                                 # Beam trawl
#          gclass = ifelse(gid %in% c(14, 30), 14, gclass),                       # rækjuvarpa
#          gclass = ifelse(gid %in% c(15, 37, 38, 40, 160, 172, 173), 15, gclass),# dredge
#          gclass = ifelse(gid %in% c(17, 18, 39), 17, gclass),                   # trap
#          gclass = ifelse(gid %in% c(43, 45), 18, gclass),                       # fishing rod
#          gclass = ifelse(is.na(gclass), 20, gclass)) %>%
#   mutate(type = case_when(gclass == 1 ~ "Long line",
#                           gclass == 2 ~ "Net",
#                           gclass == 3 ~ "Hooks",
#                           gclass == 4 ~ "Purse seine",
#                           gclass == 5 ~ "Demersal seine",
#                           gclass == 6 ~ "Demersal fish trawl",
#                           gclass == 7 ~ "Pelagic fish trawl",
#                           gclass == 8 ~ "Beam trawl",
#                           gclass == 9 ~ "Nephrops trawl",
#                           gclass == 14 ~ "Shrimp trawl",
#                           gclass == 15 ~ "Dredge",
#                           gclass == 17 ~ "Trap",
#                           gclass == 18 ~ "Fishing rod",
#                           gclass == 20 ~ "Miscellaneous")) %>%
#   select(gid, lysing, description, gclass, type) %>%
#   mutate(gid = as.integer(gid), glcass = as.integer(gclass)) %>%
#   rename_all(toupper)
#
# # HERE we should make up a metier list, a la vms
#
# dbWriteTable(con, name = "GEAR", value = Gear, overwrite = TRUE)

gear_table <- function(con) {
  tbl_mar(con, "ops$einarhj.GEAR")
}

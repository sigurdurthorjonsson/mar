#' Lesa vms gögn
#'
#' Athugið aðgangur er takmarkaður við fáa notendur á Hafrannsóknastofnun
#'
#' @name stk_trail
#'
#' @param con XXX1
#' @param year XXX2
#'
#' @export
#'
stk_trail <- function(con, year) {

  q <-
    tbl_mar(con, "stk.trail") %>%
    dplyr::mutate(lon = poslon * 180 / pi,
                  lat = poslat * 180 / pi,
                  heading = heading * 180 / pi,
                  speed = speed * 3600/1852)
  if(!missing(year)) {
    y1 <- paste0(year, "-01-01")
    y2 <- paste0(year + 1, "-01-01")
    q <-
      q %>%
      dplyr::filter(recdate >= to_date(y1, "YYYY:MM:DD"),
                    recdate   <  to_date(y2, "YYYY:MM:DD"))
  }

  q %>%
    dplyr::select(mid = mobileid,
                  time = recdate,
                  lon, lat, speed, heading, harborid)

}

#' @export
stk_mapdeck <- function(con, MID) {

  stk_trail(con) %>%
    dplyr::filter(mid %in% MID) %>%
    dplyr::collect(n = Inf) %>%
    dplyr::mutate(speed = ifelse(speed > 10, 10, speed)) %>%
    mapdeck::mapdeck() %>%
    mapdeck::add_scatterplot(lon = "lon",
                             lat = "lat",
                             fill_colour = "speed",
                             layer_id = "track",
                             palette = "inferno")

}


# Not unique vid by mobileid
#   101548
#
#' @export
stk_mobile <- function(con, correct = FALSE, vidmatch = FALSE, classify = FALSE) {

  q <-
    tbl_mar(con, "stk.mobile") %>%
    dplyr::select(mid = mobileid, localid, globalid)

  if( correct ) {

    # NOTE: There are duplicate mid below, will only match "vessel"
    #       first in the list

    q <-
      q  %>%
      dplyr::mutate(localid_original = localid) %>%
      # Correcting icelandic vessels
      #   NOTE 2019-07-21 mid 133558 is old SISIMIUT now reflagged in Iceland
      #        mt states IMO 9039779, which is old vid 2173
      dplyr::mutate(localid = dplyr::case_when(mid == 102795 ~ "2848",    # Ambassador, passenger vessel
                                               mid == 133558 ~ "2173",    # Tómas Þorvaldsson GK-10 - gamli Sisimiut
                                               mid == 101078 ~ "2549",    # Þór HF-4
                                               mid == 127288 ~ "-----",   # Eitthvurt útlenskt skip, ekki vid = 2276
                                               mid == 101069 ~ "1275",    # Jón Vídalín
                                               mid == 102100 ~ "1272",    # Sturla GK-12
                                               mid == 101775 ~ "1752",    # Brynjólfur VE-3
                                               mid == 102571 ~ "1281",    # Múlaberg
                                               mid == 101878 ~ "1578",    # Ottó N Þorláksson VE-5
                                               mid == 101680 ~ "259",     # Jökull ÞH-259
                                               mid == 103772 ~ "2940",    # Hafborg EA-152
                                               mid == 102497 ~ "2787",    # Andrea AK-0
                                               mid == 102515 ~ "2643",    # Júpíter ÞH-363
                                               mid == 102284 ~ "2917",    # Sólberg ÓF-1
                                               mid == 103015 ~ "2702",    # Gandí VE-171
                                               mid == 101776 ~ "1512",    # Skarfur GK-666 ????
                                               mid == 101499 ~ "1809",    # JÓNA EÐVALDS II    SF208
                                               mid == 101429 ~ "1066",    # Ægir RE-0
                                               mid == 101444 ~ "1421",    # Týr RE-0
                                               mid == 101485 ~ "130",     # Bjarnarey VE-21
                                               mid == 101783 ~ "1413",    # Harpa VE-25
                                               mid == 102101 ~ "2074",    # Baldur RE-0
                                               mid == 102965 ~ "1337",    # Skafti HF-48
                                               mid == 103765 ~ "997",     # Hvalur 9 RE-399
                                               mid == 107645 ~ "1937",    # Björgvin EA-311
                                               mid == 121166 ~ "2906",    # Dagur SK-17
                                               mid == 127224 ~ "2890",    # Akurey AK-10
                                               mid == 102817 ~ "-----",   # Útlenskt skip, líklega áður 1552 Már SH-127 imo: 7827732
                                               mid == 101439 ~ "2904",    # Páll Pálsson ÍS-102 - NOTE: overwrote old vid
                                               mid == 101545 ~ "2894",    # Björg EA-7  - NOTE: overwrote old vid
                                               mid == 102561 ~ "2895",    # Viðey RE-50
                                               mid == 103251 ~ "2948",    # Barkur
                                               TRUE ~ localid)) %>%
      # "Correcting" foreign vessels
      # NOTE: There are duplicate mid below, will only match "vessel"
      #       first in the list
      dplyr::mutate(localid = dplyr::case_when(mid == 132559 ~ "3781",
                                               mid == 129877 ~ "3782",
                                               mid == 121901 ~ "3783",
                                               mid == 129634 ~ "3784",
                                               mid == 132902 ~ "3786",
                                               mid == 102491 ~ "3788",
                                               mid == 101841 ~ "3789",
                                               mid == 130512 ~ "3791",
                                               mid == 102110 ~ "3792",
                                               mid == 102167 ~ "3793",
                                               mid == 129362 ~ "3796",
                                               mid == 126206 ~ "3800",
                                               mid == 127701 ~ "3801",
                                               mid == 119814 ~ "3802",
                                               mid == 126515 ~ "3803",
                                               mid == 102396 ~ "3804",
                                               mid == 124173 ~ "3805",
                                               mid == 126762 ~ "3806",
                                               mid == 113009 ~ "3809",
                                               mid == 122070 ~ "3811",
                                               mid == 118708 ~ "3813",
                                               mid == 102397 ~ "3814",
                                               mid == 124039 ~ "3815",
                                               mid == 124046 ~ "3816",
                                               mid == 121085 ~ "3817",
                                               mid == 121127 ~ "3818",
                                               mid == 116884 ~ "3819",
                                               mid == 121086 ~ "3820",
                                               mid == 121125 ~ "3821",
                                               mid == 121124 ~ "3822",
                                               mid == 113104 ~ "3823",
                                               mid == 112286 ~ "3824",
                                               mid == 112982 ~ "3825",
                                               mid == 113082 ~ "3826",
                                               mid == 102448 ~ "3827",
                                               mid == 119505 ~ "3828",
                                               mid == 118584 ~ "3829",
                                               mid == 102155 ~ "3832",
                                               mid == 117302 ~ "3833",
                                               mid == 101607 ~ "3834",
                                               mid == 116403 ~ "3835",
                                               mid == 116404 ~ "3836",
                                               mid == 112505 ~ "3837",
                                               mid == 114583 ~ "3838",
                                               mid == 102478 ~ "3839",
                                               mid == 109703 ~ "3840",
                                               mid == 107623 ~ "3842",
                                               mid == 112823 ~ "3843",
                                               mid == 114022 ~ "3844",
                                               mid == 113822 ~ "3846",
                                               mid == 113786 ~ "3847",
                                               mid == 113750 ~ "3848",
                                               mid == 112505 ~ "3849",
                                               mid == 111083 ~ "3850",
                                               mid == 113745 ~ "3852",
                                               mid == 124049 ~ "3853",
                                               mid == 108867 ~ "3854",
                                               mid == 102387 ~ "3856",
                                               mid == 112543 ~ "3857",
                                               mid == 112123 ~ "3858",
                                               mid == 116522 ~ "3859",
                                               mid == 112407 ~ "3860",
                                               mid == 112184 ~ "3861",
                                               mid == 114686 ~ "3862",
                                               mid == 112183 ~ "3863",
                                               mid == 112562 ~ "3864",
                                               mid == 111882 ~ "3865",
                                               mid == 102290 ~ "3866",
                                               mid == 109802 ~ "3868",
                                               mid == 109722 ~ "3869",
                                               mid == 109482 ~ "3870",
                                               mid == 107824 ~ "3871",
                                               mid == 108629 ~ "3872",
                                               mid == 112684 ~ "3873",
                                               mid == 110344 ~ "3874",
                                               mid == 102140 ~ "3875",
                                               mid == 109401 ~ "3876",
                                               mid == 112909 ~ "3877",
                                               mid == 113465 ~ "3878",
                                               mid == 109391 ~ "3879",
                                               mid == 101812 ~ "3880",
                                               mid == 109343 ~ "3881",
                                               mid == 109349 ~ "3882",
                                               mid == 101819 ~ "3883",
                                               mid == 101816 ~ "3884",
                                               mid == 109347 ~ "3885",
                                               mid == 108368 ~ "3886",
                                               mid == 109346 ~ "3887",
                                               mid == 105431 ~ "3888",
                                               mid == 109264 ~ "3889",
                                               mid == 109022 ~ "3890",
                                               mid == 105273 ~ "3891",
                                               mid == 102063 ~ "3892",
                                               mid == 101656 ~ "3893",
                                               mid == 130618 ~ "3894",
                                               mid == 102340 ~ "3895",
                                               mid == 108563 ~ "3898",
                                               mid == 101815 ~ "3900",
                                               mid == 108363 ~ "3901",
                                               mid == 108323 ~ "3902",
                                               mid == 108342 ~ "3904",
                                               mid == 108362 ~ "3905",
                                               mid == 108042 ~ "3906",
                                               mid == 105457 ~ "3907",
                                               mid == 107825 ~ "3909",
                                               mid == 101553 ~ "3912",
                                               mid == 102098 ~ "3913",
                                               mid == 107644 ~ "3914",
                                               mid == 105961 ~ "3916",
                                               mid == 108705 ~ "3918",
                                               mid == 104572 ~ "3919",
                                               mid == 107525 ~ "3920",
                                               mid == 101715 ~ "3921",
                                               mid == 102275 ~ "3922",
                                               mid == 101819 ~ "3924",
                                               mid == 101715 ~ "3925",
                                               mid == 107405 ~ "3926",
                                               mid == 102436 ~ "3927",
                                               mid == 102069 ~ "3928",
                                               mid == 101904 ~ "3929",
                                               mid == 107042 ~ "3931",
                                               mid == 102838 ~ "3932",
                                               mid == 102040 ~ "3937",
                                               mid == 102411 ~ "3938",
                                               mid == 105775 ~ "3940",
                                               mid == 106787 ~ "3941",
                                               mid == 101925 ~ "3942",
                                               mid == 102070 ~ "3943",
                                               mid == 107623 ~ "3944",
                                               mid == 108385 ~ "3949",
                                               mid == 110043 ~ "3953",
                                               mid == 101820 ~ "3968",
                                               mid == 101821 ~ "3969",
                                               mid == 102607 ~ "3972",
                                               mid == 102614 ~ "3975",
                                               mid == 102608 ~ "3978",
                                               mid == 102260 ~ "3979",
                                               mid == 101812 ~ "3980",
                                               mid == 102622 ~ "3983",
                                               mid == 101921 ~ "3986",
                                               mid == 101818 ~ "3988",
                                               mid == 101913 ~ "3989",
                                               mid == 101814 ~ "3990",
                                               mid == 102613 ~ "3991",
                                               mid == 106340 ~ "3994",
                                               mid == 101842 ~ "4000",
                                               mid == 101816 ~ "4001",
                                               mid == 101920 ~ "4003",
                                               mid == 102184 ~ "4009",
                                               mid == 102206 ~ "4010",
                                               mid == 101803 ~ "4025",
                                               mid == 101920 ~ "4026",
                                               mid == 101896 ~ "4027",
                                               mid == 102355 ~ "4045",
                                               mid == 101800 ~ "4046",
                                               mid == 105297 ~ "4047",
                                               mid == 101518 ~ "4048",
                                               mid == 102656 ~ "4049",
                                               mid == 102656 ~ "4050",
                                               mid == 101923 ~ "4052",
                                               mid == 101633 ~ "4054",
                                               mid == 105243 ~ "4057",
                                               mid == 103037 ~ "4087",
                                               mid == 102891 ~ "4123",
                                               mid == 102609 ~ "4129",
                                               mid == 102395 ~ "4148",
                                               mid == 101828 ~ "4164",
                                               mid == 102625 ~ "4165",
                                               mid == 106564 ~ "4169",
                                               mid == 104991 ~ "4172",
                                               mid == 101841 ~ "4199",
                                               mid == 102634 ~ "4217",
                                               mid == 102228 ~ "4235",
                                               mid == 102199 ~ "4240",
                                               mid == 102636 ~ "4242",
                                               mid == 101846 ~ "4243",
                                               mid == 102184 ~ "4247",
                                               mid == 102206 ~ "4248",
                                               mid == 102047 ~ "4250",
                                               mid == 109043 ~ "4255",
                                               mid == 102818 ~ "4262",
                                               mid == 102527 ~ "4264",
                                               mid == 109400 ~ "4269",
                                               mid == 102179 ~ "4270",
                                               mid == 102399 ~ "4271",
                                               mid == 102627 ~ "4276",
                                               mid == 102605 ~ "4277",
                                               mid == 105652 ~ "4279",
                                               mid == 108368 ~ "4282",
                                               mid == 102801 ~ "4283",
                                               mid == 102267 ~ "4284",
                                               mid == 102399 ~ "4286",
                                               mid == 102687 ~ "4291",
                                               mid == 102714 ~ "4292",
                                               mid == 101686 ~ "4296",
                                               mid == 108904 ~ "4297",
                                               mid == 105123 ~ "4299",
                                               mid == 107968 ~ "4300",
                                               mid == 104532 ~ "4303",
                                               mid == 130279 ~ "4304",
                                               mid == 103170 ~ "4306",
                                               mid == 121583 ~ "4307",
                                               mid == 102767 ~ "4309",
                                               mid == 102702 ~ "4312",
                                               mid == 101438 ~ "4313",
                                               mid == 102426 ~ "4314",
                                               mid == 104572 ~ "4317",
                                               mid == 101459 ~ "4318",
                                               mid == 102383 ~ "4321",
                                               mid == 102066 ~ "4323",
                                               mid == 102720 ~ "4324",
                                               mid == 102272 ~ "4325",
                                               mid == 101811 ~ "4326",
                                               mid == 114269 ~ "4329",
                                               mid == 107683 ~ "4331",
                                               mid == 101926 ~ "4332",
                                               mid == 106185 ~ "4334",
                                               mid == 101930 ~ "4335",
                                               mid == 101799 ~ "4336",
                                               mid == 101923 ~ "4337",
                                               mid == 104691 ~ "4338",
                                               mid == 105296 ~ "4339",
                                               mid == 106662 ~ "4340",
                                               mid == 109425 ~ "4342",
                                               mid == 108369 ~ "4344",
                                               mid == 102838 ~ "4345",
                                               mid == 105818 ~ "4346",
                                               mid == 106786 ~ "4348",
                                               mid == 114703 ~ "4350",
                                               mid == 106725 ~ "4355",
                                               mid == 102047 ~ "4356",
                                               mid == 102474 ~ "4357",
                                               mid == 102044 ~ "4358",
                                               mid == 101521 ~ "4359",
                                               mid == 106019 ~ "4361",
                                               mid == 102074 ~ "4362",
                                               mid == 105813 ~ "4364",
                                               mid == 104635 ~ "4365",
                                               mid == 127343 ~ "4366",
                                               mid == 105151 ~ "4368",
                                               mid == 104431 ~ "4370",
                                               mid == 101937 ~ "4371",
                                               mid == 102380 ~ "4372",
                                               mid == 107983 ~ "4373",
                                               mid == 106038 ~ "4374",
                                               mid == 105012 ~ "4375",
                                               mid == 107029 ~ "4376",
                                               mid == 105818 ~ "4380",
                                               mid == 102059 ~ "4381",
                                               mid == 106023 ~ "4384",
                                               mid == 102715 ~ "4385",
                                               mid == 106041 ~ "4386",
                                               mid == 106280 ~ "4387",
                                               mid == 133224 ~ "4388",
                                               mid == 108502 ~ "4389",
                                               mid == 114229 ~ "4390",
                                               mid == 106340 ~ "4391",
                                               mid == 120225 ~ "4394",
                                               mid == 101821 ~ "4395",
                                               mid == 101920 ~ "4396",
                                               mid == 102263 ~ "4397",
                                               mid == 106563 ~ "4398",
                                               mid == 101794 ~ "4399",
                                               mid == 105154 ~ "4401",
                                               mid == 101520 ~ "4422",
                                               mid == 102400 ~ "4424",
                                               mid == 101521 ~ "4425",
                                               mid == 102088 ~ "4426",
                                               mid == 102487 ~ "4432",
                                               mid == 102180 ~ "4434",
                                               mid == 101915 ~ "4438",
                                               mid == 102055 ~ "4453",
                                               mid == 101794 ~ "4460",
                                               mid == 110622 ~ "4465",
                                               mid == 101916 ~ "4467",
                                               mid == 107422 ~ "4480",
                                               mid == 101802 ~ "4482",
                                               mid == 106055 ~ "4483",
                                               mid == 102633 ~ "4486",
                                               mid == 102606 ~ "4488",
                                               mid == 101734 ~ "4489",
                                               mid == 102629 ~ "4490",
                                               mid == 102639 ~ "4506",
                                               mid == 113822 ~ "4541",
                                               mid == 106258 ~ "4547",
                                               mid == 102383 ~ "4564",
                                               mid == 102712 ~ "4574",
                                               mid == 108322 ~ "4597",
                                               mid == 101705 ~ "4598",
                                               mid == 107824 ~ "4606",
                                               mid == 101790 ~ "4637",
                                               mid == 101703 ~ "4686",
                                               mid == 101817 ~ "4687",
                                               mid == 107404 ~ "4688",
                                               mid == 101706 ~ "4690",
                                               mid == 101919 ~ "4691",
                                               mid == 102259 ~ "4696",
                                               mid == 102265 ~ "4697",
                                               mid == 101822 ~ "4699",
                                               mid == 102257 ~ "4700",
                                               mid == 102619 ~ "4704",
                                               mid == 108366 ~ "4707",
                                               mid == 105154 ~ "4709",
                                               mid == 101813 ~ "4713",
                                               mid == 102621 ~ "4720",
                                               mid == 105431 ~ "4721",
                                               mid == 102622 ~ "4727",
                                               mid == 101854 ~ "4731",
                                               mid == 102324 ~ "4732",
                                               mid == 101827 ~ "4738",
                                               mid == 104355 ~ "4753",
                                               mid == 101639 ~ "4754",
                                               mid == 102176 ~ "4755",
                                               mid == 102474 ~ "4757",
                                               mid == 102389 ~ "4760",
                                               mid == 102142 ~ "4761",
                                               mid == 101644 ~ "4762",
                                               mid == 102044 ~ "4771",
                                               mid == 102067 ~ "4778",
                                               mid == 101922 ~ "4802",
                                               mid == 104776 ~ "4803",
                                               mid == 102140 ~ "4807",
                                               mid == 102401 ~ "4809",
                                               mid == 102472 ~ "4811",
                                               mid == 101433 ~ "4820",
                                               mid == 101540 ~ "4848",
                                               mid == 105983 ~ "4858",
                                               mid == 102170 ~ "4864",
                                               mid == 106982 ~ "4885",
                                               mid == 101704 ~ "4886",
                                               mid == 102275 ~ "4890",
                                               mid == 102624 ~ "4894",
                                               mid == 102632 ~ "4896",
                                               mid == 102626 ~ "4908",
                                               mid == 101810 ~ "4909",
                                               mid == 101819 ~ "4917",
                                               mid == 102438 ~ "4930",
                                               mid == 102249 ~ "4940",
                                               mid == 102198 ~ "4941",
                                               mid == 101428 ~ "4947",
                                               mid == 102262 ~ "4950",
                                               mid == 101700 ~ "4953",
                                               mid == 105978 ~ "4956",
                                               mid == 102041 ~ "4977",
                                               mid == 101804 ~ "4981",
                                               mid == 101815 ~ "4986",
                                               mid ==	102465 ~ "4028",
                                               mid ==	101792 ~ "4406",
                                               mid ==	108202 ~ "4969",
                                               mid ==	102881 ~ "4238",
                                               mid ==	121707 ~ "4159",
                                               mid ==	119088 ~ "3792",
                                               mid ==	107084 ~ "4857",
                                               mid ==	105825 ~ "4125",
                                               mid ==	102186 ~ "4210",
                                               mid ==	102423 ~ "4616",
                                               mid ==	105792 ~ "4729",
                                               mid == 102432 ~ "4786",
                                               mid ==	128455 ~ "3828",
                                               mid ==	104333 ~ "4232",
                                               mid ==	105816 ~ "4524",
                                               mid ==	102057 ~ "4928",
                                               mid ==	104213 ~ "4779",
                                               mid ==	106184 ~ "4922",
                                               mid ==	127307 ~ "4086",
                                               TRUE ~ localid))
  }

  if( vidmatch ) {

    # There must be a neater way :-)
    cn1 <- as.character(1:1000)
    cn2 <- as.character(1001:2000)
    cn3 <- as.character(2001:3000)
    cn4 <- as.character(3001:4000)
    cn5 <- as.character(4001:5000)
    cn6 <- as.character(5001:6000)
    cn7 <- as.character(6001:7000)
    cn8 <- as.character(7001:8000)
    cn9 <- as.character(8001:9000)
    cn10 <- as.character(9001:9997)
    q <-
      q %>%
      dplyr::mutate(vid =  dplyr::case_when(localid %in% cn1 ~ localid,
                                            localid %in% cn2 ~ localid,
                                            localid %in% cn3 ~ localid,
                                            localid %in% cn4 ~ localid,
                                            localid %in% cn5 ~ localid,
                                            localid %in% cn6 ~ localid,
                                            localid %in% cn7 ~ localid,
                                            localid %in% cn8 ~ localid,
                                            localid %in% cn9 ~ localid,
                                            localid %in% cn10 ~ localid,
                                            TRUE ~ NA_character_)) %>%
      dplyr::mutate(vid2 = dplyr::case_when(globalid %in% cn1 ~ globalid,
                                            globalid %in% cn2 ~ globalid,
                                            globalid %in% cn3 ~ globalid,
                                            globalid %in% cn4 ~ globalid,
                                            globalid %in% cn5 ~ globalid,
                                            globalid %in% cn6 ~ globalid,
                                            globalid %in% cn7 ~ globalid,
                                            globalid %in% cn8 ~ globalid,
                                            globalid %in% cn9 ~ globalid,
                                            globalid %in% cn10 ~ globalid,
                                            TRUE ~ NA_character_)) %>%
      dplyr::mutate(vid = as.integer(vid),
                    vid2 = as.integer(vid2),
                    vid = ifelse(is.na(vid), vid2, vid)) %>%
      select(-vid2)
  }


  if( classify ) {

    q <-
      q %>%
      left_join(mar:::vessel_mmsi(con) %>%
                  select(vid, mmsi) %>%
                  filter(!is.na(vid)),
                by = "vid")
    q <-
      q %>%
      mutate(bauja = ifelse(toupper(str_sub(globalid, 5, 9)) %in% c("_NET_", "_NET1", "_NET2", "_NET3", "_NET4"),
                            "hi",
                            NA)) %>%
      # NOTE Code for just finding numericals in the global string since below NOT 100 foolproof
      mutate(gid_temp = str_trim(globalid)) %>%
      mutate(mmsi = case_when(!is.na(mmsi) ~ mmsi,
                              nchar(str_trim(gid_temp)) == 9 &
                                str_sub(gid_temp, 1, 1) %in% c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") &
                                is.na(bauja) ~ gid_temp,
                              TRUE ~ NA_character_)) %>%
      select(-gid_temp)
    # mutate(mmsi = ifelse(nchar(str_trim(globalid)) == 9 &
    #                        str_sub(globalid, 1, 1) %in% c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") &
    #                        is.na(bauja),
    #                      str_trim(globalid),
    #                      NA_character_))


    q <-
      q %>%
      mutate(mmsi.mid = case_when(as.integer(str_sub(mmsi, 1, 1)) %in% c("2", "3", "4", "5", "6", "7") ~ str_sub(mmsi, 1, 3),
                                  str_sub(mmsi, 1, 2) %in% c("98", "99") ~ str_sub(mmsi, 3, 5),
                                  TRUE ~ NA_character_))

    q <-
      q %>%
      left_join(mar:::vessel_mid(con) %>%
                  select(mmsi.mid = mid, mid_iso2 = iso2),
                by = "mmsi.mid")

    q <-
      q %>%
      mutate(class = case_when(str_sub(mmsi, 1, 1) == "1" ~ "sar aircraft",
                               str_sub(mmsi, 1, 1) %in% c("2", "3", "4", "5", "6", "7") ~ "vessel",
                               str_sub(mmsi, 1, 1) == "8" ~ "handheld VHF transceiver",
                               str_sub(mmsi, 1, 2) == "99" ~ "bauja",
                               str_sub(mmsi, 1, 2) == "98" ~ "sibling craft",
                               str_sub(mmsi, 1, 3) == "970" ~ "sar transponders",
                               str_sub(mmsi, 1, 3) == "972" ~ "man overboard",
                               !is.na(mmsi.mid) & is.na(as.integer(str_sub(mmsi, 1, 2))) ~ "vessel",
                               localid_original %in% c("9999", "9998") |
                                 globalid %in% c("Surtseyja", "Straumnes", "Steinanes", "Haganes_K", "Eyri_Kvi_", "Bakkafjar",
                                                 "Laugardal", "BorgfjE P", "Gemlufall", "Sjokvi", "Straumduf", "Eyrarhlid",
                                                 "Hvalnes", "Straumm?l", "V_Blafj P", "Isafj.dju", "Rey?arfjo",
                                                 "VidarfjAI", "KLIF AIS",  "VadlahAIS", "Hafell_AI", "TIND_AIS",  "Storhof?i",
                                                 "Helguv", "Laugarb.f", "Grimseyja", "G.skagi",   "Grindavik", "Hornafjar",
                                                 "Flateyjar", "Kogurdufl", "Blakkur.d", "Bakkafjor", "Hvalbakur", "SUGANDI_A",
                                                 "TJALDANES", "Sjokvi-4",  "Kvi-0 Hri", "Sjokvi-2", "Sjokvi-3", "Snaefj1",
                                                 "Snaefj2", "Lande", "Sjomsk", "TJALD.NES", "illvid_p", "BLAKKSNES", "V_Sfell B",
                                                 "HOF", "118084", "Illvi?rah", "Miðfegg P", "BASE11", "Borgarfj ",
                                                 "V_Hofsos", "V_Hofsos ", "Arnarfjor", "Trackw", "SUGANDAFJ",
                                                 "BORGARÍS", "BORGARIS", "BORGARIS0", "BORGARIS1",
                                                 "TEST", "SN-105717") ~ "fixed",
                               !is.na(bauja) ~ "bauja",
                               !is.na(vid) ~ "vessel",
                               mid %in% c(102817, 127288) ~ "vessel",
                               mid %in% c(118084, 103135) ~ "fixed",
                               TRUE ~ NA_character_))

    # NOTE: CHECK HERE
    q <-
      q %>%
      mutate(cs = ifelse(class == "vessel" | is.na(class), globalid, NA_character_),
             cs = case_when(cs == "THAE" & vid == 2549 ~ "TFAE",
                            str_sub(cs, 1, 4) == "TMP_" ~  NA_character_,
                            TRUE ~ cs),
             cs_prefix = str_sub(cs, 1, 2)) %>%
      left_join(mar:::vessel_csprefix(con) %>% select(cs_prefix, cs_iso2 = iso2),
                by = "cs_prefix")  %>%
      mutate(cs = ifelse(!is.na(cs_iso2), cs, NA_character_))

    # NOTE: This may have to be put upstream
    #q <-
    #  q %>%
    #  mutate(vid = ifelse(!between(vid, 3700, 4999) & cs_iso2 != "IS", NA, vid))
    q <-
      q %>%
      mutate(vid.aux = ifelse(class == "bauja" & is.na(cs), str_sub(globalid, 1, 4), NA_character_)) %>%
      select(-c(bauja, mmsi.mid))
  }


  return(q)

}


# library(mar)
# con <- connect_mar()
# d <-
#   stk_mobile(con, TRUE, TRUE, TRUE) %>%
#   left_join(stk_trail(con) %>%
#               group_by(mid) %>%
#               summarise(n.vms = n())) %>%
#   collect(n = Inf)
# d <-
#   d %>%
#   rename_all(toupper)
# dbWriteTable(con, name = "STK_MID_VID", value = d, overwrite = TRUE)

stk_mid_vid <- function(con) {
  tbl_mar(con, "ops$einarhj.STK_MID_VID")
}

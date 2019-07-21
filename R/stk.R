stk_mobile <- function(con, correct = FALSE, vidmatch = FALSE, classify = FALSE) {

  q <-
    tbl_mar(con, "stk.mobile") %>%
    dplyr::select(mobileid, localid, globalid)

  if(correct) {

    # NOTE: There are duplicate mobileid below, will only match "vessel"
    #       first in the list

    q <-
      q  %>%
      dplyr::mutate(localid_original = localid) %>%
      # Correcting icelandic vessels
      #   NOTE 2019-07-21 mobileid 133558 is old SISIMIUT now reflagged in Iceland !
      #        mt states IMO 9039779, which is old vid 2173
      dplyr::mutate(localid = dplyr::case_when(mobileid == 133558 ~ "2173",    # Tómas Þorvaldsson GK-10 - gamli Sisimiut
                                               mobileid == 101078 ~ "2549",    # Þór HF-4
                                               mobileid == 127288 ~ "-----",   # Eitthvurt útlenskt skip, ekki vid = 2276
                                               mobileid == 101069 ~ "1275",    # Jón Vídalín
                                               mobileid == 102100 ~ "1272",    # Sturla GK-12
                                               mobileid == 101775 ~ "1752",    # Brynjólfur VE-3
                                               mobileid == 102571 ~ "1281",    # Múlaberg
                                               mobileid == 101878 ~ "1578",    # Ottó N Þorláksson VE-5
                                               mobileid == 101680 ~ "259",     # Jökull ÞH-259
                                               mobileid == 103772 ~ "2940",    # Hafborg EA-152
                                               mobileid == 102497 ~ "2787",    # Andrea AK-0
                                               mobileid == 102515 ~ "2643",    # Júpíter ÞH-363
                                               mobileid == 102284 ~ "2917",    # Sólberg ÓF-1
                                               mobileid == 103015 ~ "2702",    # Gandí VE-171
                                               mobileid == 101776 ~ "1512",    # Skarfur GK-666 ????
                                               mobileid == 101499 ~ "1809",    # JÓNA EÐVALDS II    SF208
                                               mobileid == 101429 ~ "1066",    # Ægir RE-0
                                               mobileid == 101444 ~ "1421",    # Týr RE-0
                                               mobileid == 101485 ~ "130",     # Bjarnarey VE-21
                                               mobileid == 101783 ~ "1413",    # Harpa VE-25
                                               mobileid == 102101 ~ "2074",    # Baldur RE-0
                                               mobileid == 102965 ~ "1337",    # Skafti HF-48
                                               mobileid == 103765 ~ "997",     # Hvalur 9 RE-399
                                               mobileid == 107645 ~ "1937",    # Björgvin EA-311
                                               mobileid == 121166 ~ "2906",    # Dagur SK-17
                                               mobileid == 127224 ~ "2890",    # Akurey AK-10
                                               mobileid == 102817 ~ "-----",   # Útlenskt skip, líklega áður 1552 Már SH-127 imo: 7827732
                                               mobileid == 101439 ~ "2904",    # Páll Pálsson ÍS-102 - NOTE: overwrote old vid
                                               mobileid == 101545 ~ "2894",    # Björg EA-7  - NOTE: overwrote old vid
                                               mobileid == 102561 ~ "2895",    # Viðey RE-50
                                               TRUE ~ localid)) %>%
      # "Correcting" foreign vessels
      # NOTE: There are duplicate mobileid below, will only match "vessel"
      #       first in the list
      dplyr::mutate(localid = dplyr::case_when(mobileid == 132559 ~ "3781",
                                               mobileid == 129877 ~ "3782",
                                               mobileid == 121901 ~ "3783",
                                               mobileid == 129634 ~ "3784",
                                               mobileid == 132902 ~ "3786",
                                               mobileid == 102491 ~ "3788",
                                               mobileid == 101841 ~ "3789",
                                               mobileid == 130512 ~ "3791",
                                               mobileid == 102110 ~ "3792",
                                               mobileid == 102167 ~ "3793",
                                               mobileid == 129362 ~ "3796",
                                               mobileid == 126206 ~ "3800",
                                               mobileid == 127701 ~ "3801",
                                               mobileid == 119814 ~ "3802",
                                               mobileid == 126515 ~ "3803",
                                               mobileid == 102396 ~ "3804",
                                               mobileid == 124173 ~ "3805",
                                               mobileid == 126762 ~ "3806",
                                               mobileid == 113009 ~ "3809",
                                               mobileid == 122070 ~ "3811",
                                               mobileid == 118708 ~ "3813",
                                               mobileid == 102397 ~ "3814",
                                               mobileid == 124039 ~ "3815",
                                               mobileid == 124046 ~ "3816",
                                               mobileid == 121085 ~ "3817",
                                               mobileid == 121127 ~ "3818",
                                               mobileid == 116884 ~ "3819",
                                               mobileid == 121086 ~ "3820",
                                               mobileid == 121125 ~ "3821",
                                               mobileid == 121124 ~ "3822",
                                               mobileid == 113104 ~ "3823",
                                               mobileid == 112286 ~ "3824",
                                               mobileid == 112982 ~ "3825",
                                               mobileid == 113082 ~ "3826",
                                               mobileid == 102448 ~ "3827",
                                               mobileid == 119505 ~ "3828",
                                               mobileid == 118584 ~ "3829",
                                               mobileid == 102155 ~ "3832",
                                               mobileid == 117302 ~ "3833",
                                               mobileid == 101607 ~ "3834",
                                               mobileid == 116403 ~ "3835",
                                               mobileid == 116404 ~ "3836",
                                               mobileid == 112505 ~ "3837",
                                               mobileid == 114583 ~ "3838",
                                               mobileid == 102478 ~ "3839",
                                               mobileid == 109703 ~ "3840",
                                               mobileid == 107623 ~ "3842",
                                               mobileid == 112823 ~ "3843",
                                               mobileid == 114022 ~ "3844",
                                               mobileid == 113822 ~ "3846",
                                               mobileid == 113786 ~ "3847",
                                               mobileid == 113750 ~ "3848",
                                               mobileid == 112505 ~ "3849",
                                               mobileid == 111083 ~ "3850",
                                               mobileid == 113745 ~ "3852",
                                               mobileid == 124049 ~ "3853",
                                               mobileid == 108867 ~ "3854",
                                               mobileid == 102387 ~ "3856",
                                               mobileid == 112543 ~ "3857",
                                               mobileid == 112123 ~ "3858",
                                               mobileid == 116522 ~ "3859",
                                               mobileid == 112407 ~ "3860",
                                               mobileid == 112184 ~ "3861",
                                               mobileid == 114686 ~ "3862",
                                               mobileid == 112183 ~ "3863",
                                               mobileid == 112562 ~ "3864",
                                               mobileid == 111882 ~ "3865",
                                               mobileid == 102290 ~ "3866",
                                               mobileid == 109802 ~ "3868",
                                               mobileid == 109722 ~ "3869",
                                               mobileid == 109482 ~ "3870",
                                               mobileid == 107824 ~ "3871",
                                               mobileid == 108629 ~ "3872",
                                               mobileid == 112684 ~ "3873",
                                               mobileid == 110344 ~ "3874",
                                               mobileid == 102140 ~ "3875",
                                               mobileid == 109401 ~ "3876",
                                               mobileid == 112909 ~ "3877",
                                               mobileid == 113465 ~ "3878",
                                               mobileid == 109391 ~ "3879",
                                               mobileid == 101812 ~ "3880",
                                               mobileid == 109343 ~ "3881",
                                               mobileid == 109349 ~ "3882",
                                               mobileid == 101819 ~ "3883",
                                               mobileid == 101816 ~ "3884",
                                               mobileid == 109347 ~ "3885",
                                               mobileid == 108368 ~ "3886",
                                               mobileid == 109346 ~ "3887",
                                               mobileid == 105431 ~ "3888",
                                               mobileid == 109264 ~ "3889",
                                               mobileid == 109022 ~ "3890",
                                               mobileid == 105273 ~ "3891",
                                               mobileid == 102063 ~ "3892",
                                               mobileid == 101656 ~ "3893",
                                               mobileid == 130618 ~ "3894",
                                               mobileid == 102340 ~ "3895",
                                               mobileid == 108563 ~ "3898",
                                               mobileid == 101815 ~ "3900",
                                               mobileid == 108363 ~ "3901",
                                               mobileid == 108323 ~ "3902",
                                               mobileid == 108342 ~ "3904",
                                               mobileid == 108362 ~ "3905",
                                               mobileid == 108042 ~ "3906",
                                               mobileid == 105457 ~ "3907",
                                               mobileid == 107825 ~ "3909",
                                               mobileid == 101553 ~ "3912",
                                               mobileid == 102098 ~ "3913",
                                               mobileid == 107644 ~ "3914",
                                               mobileid == 105961 ~ "3916",
                                               mobileid == 108705 ~ "3918",
                                               mobileid == 104572 ~ "3919",
                                               mobileid == 107525 ~ "3920",
                                               mobileid == 101715 ~ "3921",
                                               mobileid == 102275 ~ "3922",
                                               mobileid == 101819 ~ "3924",
                                               mobileid == 101715 ~ "3925",
                                               mobileid == 107405 ~ "3926",
                                               mobileid == 102436 ~ "3927",
                                               mobileid == 102069 ~ "3928",
                                               mobileid == 101904 ~ "3929",
                                               mobileid == 107042 ~ "3931",
                                               mobileid == 102838 ~ "3932",
                                               mobileid == 102040 ~ "3937",
                                               mobileid == 102411 ~ "3938",
                                               mobileid == 105775 ~ "3940",
                                               mobileid == 106787 ~ "3941",
                                               mobileid == 101925 ~ "3942",
                                               mobileid == 102070 ~ "3943",
                                               mobileid == 107623 ~ "3944",
                                               mobileid == 108385 ~ "3949",
                                               mobileid == 110043 ~ "3953",
                                               mobileid == 101820 ~ "3968",
                                               mobileid == 101821 ~ "3969",
                                               mobileid == 102607 ~ "3972",
                                               mobileid == 102614 ~ "3975",
                                               mobileid == 102608 ~ "3978",
                                               mobileid == 102260 ~ "3979",
                                               mobileid == 101812 ~ "3980",
                                               mobileid == 102622 ~ "3983",
                                               mobileid == 101921 ~ "3986",
                                               mobileid == 101818 ~ "3988",
                                               mobileid == 101913 ~ "3989",
                                               mobileid == 101814 ~ "3990",
                                               mobileid == 102613 ~ "3991",
                                               mobileid == 106340 ~ "3994",
                                               mobileid == 101842 ~ "4000",
                                               mobileid == 101816 ~ "4001",
                                               mobileid == 101920 ~ "4003",
                                               mobileid == 102184 ~ "4009",
                                               mobileid == 102206 ~ "4010",
                                               mobileid == 101803 ~ "4025",
                                               mobileid == 101920 ~ "4026",
                                               mobileid == 101896 ~ "4027",
                                               mobileid == 102355 ~ "4045",
                                               mobileid == 101800 ~ "4046",
                                               mobileid == 105297 ~ "4047",
                                               mobileid == 101518 ~ "4048",
                                               mobileid == 102656 ~ "4049",
                                               mobileid == 102656 ~ "4050",
                                               mobileid == 101923 ~ "4052",
                                               mobileid == 101633 ~ "4054",
                                               mobileid == 105243 ~ "4057",
                                               mobileid == 102891 ~ "4123",
                                               mobileid == 102609 ~ "4129",
                                               mobileid == 102395 ~ "4148",
                                               mobileid == 101828 ~ "4164",
                                               mobileid == 102625 ~ "4165",
                                               mobileid == 106564 ~ "4169",
                                               mobileid == 104991 ~ "4172",
                                               mobileid == 101841 ~ "4199",
                                               mobileid == 102634 ~ "4217",
                                               mobileid == 102228 ~ "4235",
                                               mobileid == 102199 ~ "4240",
                                               mobileid == 102636 ~ "4242",
                                               mobileid == 101846 ~ "4243",
                                               mobileid == 102184 ~ "4247",
                                               mobileid == 102206 ~ "4248",
                                               mobileid == 102047 ~ "4250",
                                               mobileid == 109043 ~ "4255",
                                               mobileid == 102818 ~ "4262",
                                               mobileid == 102527 ~ "4264",
                                               mobileid == 109400 ~ "4269",
                                               mobileid == 102179 ~ "4270",
                                               mobileid == 102399 ~ "4271",
                                               mobileid == 102627 ~ "4276",
                                               mobileid == 102605 ~ "4277",
                                               mobileid == 105652 ~ "4279",
                                               mobileid == 108368 ~ "4282",
                                               mobileid == 102801 ~ "4283",
                                               mobileid == 102267 ~ "4284",
                                               mobileid == 102399 ~ "4286",
                                               mobileid == 102687 ~ "4291",
                                               mobileid == 102714 ~ "4292",
                                               mobileid == 101686 ~ "4296",
                                               mobileid == 108904 ~ "4297",
                                               mobileid == 105123 ~ "4299",
                                               mobileid == 107968 ~ "4300",
                                               mobileid == 104532 ~ "4303",
                                               mobileid == 130279 ~ "4304",
                                               mobileid == 103170 ~ "4306",
                                               mobileid == 121583 ~ "4307",
                                               mobileid == 102767 ~ "4309",
                                               mobileid == 102702 ~ "4312",
                                               mobileid == 101438 ~ "4313",
                                               mobileid == 102426 ~ "4314",
                                               mobileid == 104572 ~ "4317",
                                               mobileid == 101459 ~ "4318",
                                               mobileid == 102383 ~ "4321",
                                               mobileid == 102066 ~ "4323",
                                               mobileid == 102720 ~ "4324",
                                               mobileid == 102272 ~ "4325",
                                               mobileid == 101811 ~ "4326",
                                               mobileid == 114269 ~ "4329",
                                               mobileid == 107683 ~ "4331",
                                               mobileid == 101926 ~ "4332",
                                               mobileid == 106185 ~ "4334",
                                               mobileid == 101930 ~ "4335",
                                               mobileid == 101799 ~ "4336",
                                               mobileid == 101923 ~ "4337",
                                               mobileid == 104691 ~ "4338",
                                               mobileid == 105296 ~ "4339",
                                               mobileid == 106662 ~ "4340",
                                               mobileid == 109425 ~ "4342",
                                               mobileid == 108369 ~ "4344",
                                               mobileid == 102838 ~ "4345",
                                               mobileid == 105818 ~ "4346",
                                               mobileid == 106786 ~ "4348",
                                               mobileid == 114703 ~ "4350",
                                               mobileid == 106725 ~ "4355",
                                               mobileid == 102047 ~ "4356",
                                               mobileid == 102474 ~ "4357",
                                               mobileid == 102044 ~ "4358",
                                               mobileid == 101521 ~ "4359",
                                               mobileid == 106019 ~ "4361",
                                               mobileid == 102074 ~ "4362",
                                               mobileid == 105813 ~ "4364",
                                               mobileid == 104635 ~ "4365",
                                               mobileid == 127343 ~ "4366",
                                               mobileid == 105151 ~ "4368",
                                               mobileid == 104431 ~ "4370",
                                               mobileid == 101937 ~ "4371",
                                               mobileid == 102380 ~ "4372",
                                               mobileid == 107983 ~ "4373",
                                               mobileid == 106038 ~ "4374",
                                               mobileid == 105012 ~ "4375",
                                               mobileid == 107029 ~ "4376",
                                               mobileid == 105818 ~ "4380",
                                               mobileid == 102059 ~ "4381",
                                               mobileid == 106023 ~ "4384",
                                               mobileid == 102715 ~ "4385",
                                               mobileid == 106041 ~ "4386",
                                               mobileid == 106280 ~ "4387",
                                               mobileid == 133224 ~ "4388",
                                               mobileid == 108502 ~ "4389",
                                               mobileid == 114229 ~ "4390",
                                               mobileid == 106340 ~ "4391",
                                               mobileid == 120225 ~ "4394",
                                               mobileid == 101821 ~ "4395",
                                               mobileid == 101920 ~ "4396",
                                               mobileid == 102263 ~ "4397",
                                               mobileid == 106563 ~ "4398",
                                               mobileid == 101794 ~ "4399",
                                               mobileid == 105154 ~ "4401",
                                               mobileid == 101520 ~ "4422",
                                               mobileid == 102400 ~ "4424",
                                               mobileid == 101521 ~ "4425",
                                               mobileid == 102088 ~ "4426",
                                               mobileid == 102487 ~ "4432",
                                               mobileid == 102180 ~ "4434",
                                               mobileid == 101915 ~ "4438",
                                               mobileid == 102055 ~ "4453",
                                               mobileid == 101794 ~ "4460",
                                               mobileid == 110622 ~ "4465",
                                               mobileid == 101916 ~ "4467",
                                               mobileid == 107422 ~ "4480",
                                               mobileid == 101802 ~ "4482",
                                               mobileid == 106055 ~ "4483",
                                               mobileid == 102633 ~ "4486",
                                               mobileid == 102606 ~ "4488",
                                               mobileid == 101734 ~ "4489",
                                               mobileid == 102629 ~ "4490",
                                               mobileid == 102639 ~ "4506",
                                               mobileid == 113822 ~ "4541",
                                               mobileid == 106258 ~ "4547",
                                               mobileid == 102383 ~ "4564",
                                               mobileid == 102712 ~ "4574",
                                               mobileid == 108322 ~ "4597",
                                               mobileid == 101705 ~ "4598",
                                               mobileid == 107824 ~ "4606",
                                               mobileid == 101790 ~ "4637",
                                               mobileid == 101703 ~ "4686",
                                               mobileid == 101817 ~ "4687",
                                               mobileid == 107404 ~ "4688",
                                               mobileid == 101706 ~ "4690",
                                               mobileid == 101919 ~ "4691",
                                               mobileid == 102259 ~ "4696",
                                               mobileid == 102265 ~ "4697",
                                               mobileid == 101822 ~ "4699",
                                               mobileid == 102257 ~ "4700",
                                               mobileid == 102619 ~ "4704",
                                               mobileid == 108366 ~ "4707",
                                               mobileid == 105154 ~ "4709",
                                               mobileid == 101813 ~ "4713",
                                               mobileid == 102621 ~ "4720",
                                               mobileid == 105431 ~ "4721",
                                               mobileid == 102622 ~ "4727",
                                               mobileid == 101854 ~ "4731",
                                               mobileid == 102324 ~ "4732",
                                               mobileid == 101827 ~ "4738",
                                               mobileid == 104355 ~ "4753",
                                               mobileid == 101639 ~ "4754",
                                               mobileid == 102176 ~ "4755",
                                               mobileid == 102474 ~ "4757",
                                               mobileid == 102389 ~ "4760",
                                               mobileid == 102142 ~ "4761",
                                               mobileid == 101644 ~ "4762",
                                               mobileid == 102044 ~ "4771",
                                               mobileid == 102067 ~ "4778",
                                               mobileid == 101922 ~ "4802",
                                               mobileid == 104776 ~ "4803",
                                               mobileid == 102140 ~ "4807",
                                               mobileid == 102401 ~ "4809",
                                               mobileid == 102472 ~ "4811",
                                               mobileid == 101433 ~ "4820",
                                               mobileid == 101540 ~ "4848",
                                               mobileid == 105983 ~ "4858",
                                               mobileid == 102170 ~ "4864",
                                               mobileid == 106982 ~ "4885",
                                               mobileid == 101704 ~ "4886",
                                               mobileid == 102275 ~ "4890",
                                               mobileid == 102624 ~ "4894",
                                               mobileid == 102632 ~ "4896",
                                               mobileid == 102626 ~ "4908",
                                               mobileid == 101810 ~ "4909",
                                               mobileid == 101819 ~ "4917",
                                               mobileid == 102438 ~ "4930",
                                               mobileid == 102249 ~ "4940",
                                               mobileid == 102198 ~ "4941",
                                               mobileid == 101428 ~ "4947",
                                               mobileid == 102262 ~ "4950",
                                               mobileid == 101700 ~ "4953",
                                               mobileid == 105978 ~ "4956",
                                               mobileid == 102041 ~ "4977",
                                               mobileid == 101804 ~ "4981",
                                               mobileid == 101815 ~ "4986",
                                               TRUE ~ localid))
  }

  if(vidmatch) {

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
      dplyr::mutate(vid1 = dplyr::case_when(localid %in% cn1 ~ localid,
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
      dplyr::mutate(vid1 = as.integer(vid1),
                    vid2 = as.integer(vid2))
  }

  if(classify) {
    q <-
      q %>%
      mutate(bauja = ifelse(toupper(str_sub(globalid, 5, 9)) %in% c("_NET_", "_NET1", "_NET2", "_NET3", "_NET4"),
                            "hi",
                            NA)) %>%
      # NOTE Code for just finding numers in the global string since below NOT 100 foolproof
      mutate(mmsi = ifelse(nchar(str_trim(globalid)) == 9 &
                             str_sub(globalid, 1, 1) %in% c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") &
                             is.na(bauja),
                           str_trim(globalid),
                           NA_character_))
    q <-
      q %>%
      mutate(mid = case_when(as.integer(str_sub(mmsi, 1, 1)) %in% c("2", "3", "4", "5", "6", "7") ~ str_sub(mmsi, 1, 3),
                             str_sub(mmsi, 1, 2) %in% c("98", "99") ~ str_sub(mmsi, 3, 5),
                             TRUE ~ NA_character_))
    q <-
      q %>%
      mutate(mmsi.class = case_when(str_sub(mmsi, 1, 1) == "1" ~ "sar aircraft",
                                    str_sub(mmsi, 1, 1) %in% c("2", "3", "4", "5", "6", "7") ~ "vessel",
                                    str_sub(mmsi, 1, 1) == "8" ~ "handheld VHF transceiver",
                                    str_sub(mmsi, 1, 2) == "99" ~ "bauja",
                                    str_sub(mmsi, 1, 2) == "98" ~ "sibling craft",
                                    str_sub(mmsi, 1, 3) == "970" ~ "sar transponders",
                                    str_sub(mmsi, 1, 3) == "972" ~ "man overboard",
                                    !is.na(mid) & is.na(as.integer(str_sub(mmsi, 1, 2))) ~ "vessel",
                                    localid_original %in% c("9999", "9998") |
                                      globalid %in% c("Surtseyja", "Straumnes", "Steinanes", "Haganes_K", "Eyri_Kvi_", "Bakkafjar",
                                                      "Laugardal", "BorgfjE P", "Gemlufall", "Sjokvi", "Straumduf", "Eyrarhlid",
                                                      "Hvalnes", "Straumm?l", "V_Blafj P", "Isafj.dju", "Rey?arfjo",
                                                      "2515036", "5200000", "xxx5", "BLAKKSNES", "V_Sfell B") ~ "fixed",
                                    !is.na(bauja) ~ "bauja",
                                    TRUE ~ NA_character_))
    q <-
      q %>%
      mutate(cs.aux =  ifelse(!is.na(bauja) &  str_sub(globalid, 1, 2) %in% c("TF", "XP"), str_sub(globalid, 1, 4), NA_character_),
             vid.aux = ifelse(!is.na(bauja) & !str_sub(globalid, 1, 2) %in% c("TF", "XP"), str_sub(globalid, 1, 4), NA_character_)) %>%
      select(-bauja)
  }

  return(q)

}


# mar

## dplyr-erized connection to MRI oracle database


```r
# devtools::install_github("bernardocaldas/dplyrOracle")
# devtools::install_github("fishvice/mar")
library(ggplot2)
library(mar)
library(dplyr)
library(dplyrOracle)
mar <- src_oracle("mar")
st <-
  lesa_stodvar(mar) %>%
  filter(ar %in% c(1985:2016),
         veidarfaeri == 73,
         synaflokkur == 30,
         tognumer < 40)
```



```r
glimpse(st)
```

```
## Observations: NA
## Variables: 64
## $ vindhradi_hnutar (int) 30, 30, 5, 5, 13, 13, 5, 37, 13, 24, 13, 18, ...
## $ sjondypi         (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ straumhradi      (dbl) NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.6, 0.5,...
## $ straumstefna     (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, 30, 30, 3...
## $ hafis            (int) 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
## $ loftvog          (int) 982, NA, 977, 999, 981, 986, NA, 976, 1000, 9...
## $ lofthiti         (dbl) -4.5, -2.0, 1.2, 1.0, 0.0, -1.4, 0.5, 0.0, 0....
## $ yfirbordshiti    (dbl) 1.1, 1.1, 1.0, 1.1, 1.0, 1.0, 1.3, 1.2, 0.2, ...
## $ botnhiti         (dbl) 1.0, 1.0, -0.1, 1.0, -0.1, 0.5, 1.0, 1.1, 3.4...
## $ sjor             (int) 4, 5, 2, 1, 3, 4, 2, 4, 5, 4, 3, 4, 2, 2, 3, ...
## $ sky              (int) 9, 7, 7, 9, 8, 9, 6, 7, 2, 4, 4, 5, 4, 5, 4, ...
## $ vedur            (int) 2, 7, 2, 1, 7, 7, 1, 7, 1, 1, 1, 1, 1, 1, 1, ...
## $ vindatt          (int) 5, 9, 5, 14, 36, 5, 11, 5, 5, 27, 23, 23, 36,...
## $ vindhradi        (int) 15, 15, 3, 3, 7, 7, 3, 19, 7, 12, 7, 9, 5, 5,...
## $ dregid_fra       (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ tog_lengd        (dbl) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ eykt             (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ togdypishiti     (dbl) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ togdypi_hift     (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ togdypi_kastad   (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ togtimi          (dbl) 63, 60, 59, 60, 65, 65, 58, 62, 70, 73, 60, 7...
## $ larett_opnun     (dbl) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ togstefna        (int) 360, 53, 15, 206, 180, 215, 53, 54, 80, 190, ...
## $ tognumer         (dbl) 13, 1, 11, 3, 13, 12, 1, 2, 5, 1, 1, 1, 2, 6,...
## $ lodrett_opnun    (dbl) 3.0, 2.6, 2.8, 2.2, NA, 2.2, 2.4, 2.4, 2.7, 2...
## $ vir_uti          (int) 375, 150, 375, 175, 550, 325, 275, 300, 250, ...
## $ toglengd         (dbl) 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, ...
## $ toghradi         (dbl) 3.8, 4.0, 4.1, 4.0, 3.7, 3.7, 4.1, 3.9, 3.4, ...
## $ togendir         (time) 1990-03-16 08:51:00, 1990-03-16 12:31:00, 19...
## $ togbyrjun        (time) 1990-03-16 07:48:00, 1990-03-16 11:31:00, 19...
## $ medferd_afla     (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ tog_aths         (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ veidarfaeri_id   (dbl) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ maelingarmenn    (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ hitamaelir_id    (dbl) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ veidisvaedi      (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ synaflokkur      (dbl) 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 3...
## $ net_nr           (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ stada_stodvar    (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ aths             (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ landsyni         (dbl) 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
## $ hnattstada       (int) -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -...
## $ fjardarreitur    (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ skiki            (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ londunarhofn     (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ heildarafli      (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ grandaralengd    (int) 45, 45, 45, 45, 45, 45, 45, 45, 35, 45, 45, 4...
## $ moskvastaerd     (int) 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 4...
## $ veidarfaeri      (int) 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 7...
## $ dypi_hift        (int) 314, 117, 315, 115, 381, 197, 228, 248, 167, ...
## $ dypi_kastad      (int) 302, 88, 311, 103, 354, 265, 218, 226, 188, 4...
## $ hift_v_lengd     (int) 203201, 200465, 192184, 211235, 183368, 18210...
## $ hift_n_breidd    (int) 663455, 663696, 663404, 664407, 664548, 66410...
## $ kastad_v_lengd   (int) 202986, 201290, 192417, 210798, 183376, 18159...
## $ kastad_n_breidd  (int) 663055, 663445, 663020, 664791, 664956, 66444...
## $ smareitur        (int) 4, 4, 4, 2, 1, 4, 3, 3, 3, 4, 1, 3, 4, 3, 1, ...
## $ reitur           (int) 670, 670, 669, 671, 668, 668, 721, 720, 462, ...
## $ stod             (int) 73, 75, 86, 57, 91, 93, 51, 66, 1, 86, 92, 97...
## $ skip             (int) 1307, 1307, 1307, 1307, 1307, 1307, 1307, 130...
## $ dags             (time) 1990-03-16, 1990-03-16, 1990-03-17, 1990-03-...
## $ leidangur        (chr) "TA1-90", "TA1-90", "TA1-90", "TA1-90", "TA1-...
## $ synis_id         (int) 44928, 44926, 45043, 44944, 45038, 45036, 449...
## $ ar               (dbl) 1990, 1990, 1990, 1990, 1990, 1990, 1990, 199...
## $ man              (dbl) 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
```



```r
st %>% 
  collect() %>% 
  mutate(lon1 = -gisland::geo_convert(kastad_v_lengd),
         lat1 =  gisland::geo_convert(kastad_n_breidd)) %>% 
  ggplot() +
  theme_minimal() +
  geom_point(aes(lon1,lat1),alpha=0.2, size=1, col="red") +
  geom_polygon(data=gisland::iceland,aes(long,lat,group=group),fill="grey90") +
  coord_map(ylim=c(62,67.8), xlim=c(-31,-9)) +
  labs(x = NULL,y = NULL, title = "Spring survey stations")
```

![](README_files/figure-html/smb1-1.png)


```r
cod <-
  lesa_stodvar(mar) %>%
  filter(ar %in% c(1985:2016),
         veidarfaeri == 73,
         synaflokkur == 30,
         tognumer < 40) %>% 
  select(synis_id, ar) %>% 
  left_join(lesa_lengdir(mar) %>%
               filter(tegund %in% 1),
            by = "synis_id") %>%
  left_join(lesa_numer(mar) %>%
              filter(tegund %in% 1) %>% 
              select(synis_id, fj_talid, fj_maelt),
            by = "synis_id") %>% 
  collect(n = Inf) 
```

```
## Joining by: "SYNIS_ID"
## Joining by: "SYNIS_ID"
## Joining by: "SYNIS_ID"
## Joining by: "SYNIS_ID"
```

```r
glimpse(cod)
```

```
## Observations: 543,384
## Variables: 9
## $ synis_id   (int) 47824, 50746, 48677, 48679, 48668, 47855, 48167, 48...
## $ ar         (dbl) 1991, 1992, 1991, 1991, 1991, 1991, 1991, 1991, 199...
## $ kynthroski (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
## $ kyn        (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
## $ fjoldi     (int) 3, 3, 1, 3, 1, 2, 2, 1, 2, 3, 3, 2, 2, 1, 3, 1, 3, ...
## $ lengd      (dbl) 71, 71, 55, 35, 58, 68, 58, 45, 46, 81, 32, 77, 31,...
## $ tegund     (int) 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
## $ fj_talid   (int) 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
## $ fj_maelt   (dbl) 149, 71, 89, 298, 145, 38, 78, 53, 106, 97, 67, 74,...
```

```r
cod %>% 
  mutate(r = (1 + fj_talid/fj_maelt),
         fjoldi = r * fjoldi,
         fjoldi = ifelse(is.na(fjoldi),0,fjoldi),
         b = fjoldi * 0.01 * lengd^3) %>% 
  group_by(ar, synis_id) %>% 
  summarise(n = sum(fjoldi),
            b = sum(b, na.rm = T)) %>% 
  ggplot(aes(ar, b)) +
  stat_summary(fun.data = "mean_cl_boot", colour = "red") +
  expand_limits(y = 0) +
  labs(x = NULL, y = NULL, title = "Cod: Bootstrap mean biomass and confidence interval") +
  scale_x_continuous(breaks = seq(1985,2015,5))
```

![](README_files/figure-html/smb2-1.png)

Doing summarization within Oracle:

```r
cod <-
  lesa_stodvar(mar) %>%
  filter(ar %in% c(1985:2016),
         veidarfaeri == 73,
         synaflokkur == 30,
         tognumer < 40) %>% 
  select(synis_id, ar) %>% 
  left_join(lesa_lengdir(mar) %>%
               filter(tegund %in% 1),
            by = "synis_id") %>%
  left_join(lesa_numer(mar) %>%
              filter(tegund %in% 1,
                     fj_maelt > 0) %>% 
              mutate(r = 1 + fj_talid/fj_maelt) %>% 
              select(synis_id, r),
            by = "synis_id") %>%
  mutate(lengd = ifelse(is.na(lengd), 0, lengd),
         fjoldi = ifelse(is.na(fjoldi), 0, fjoldi),
         r = ifelse(is.na(r), 0 , r),
         abu = r * fjoldi,
         bio = r * fjoldi * 0.01 * lengd^3) %>% 
  group_by(synis_id, ar) %>% 
  summarise(n = sum(abu),
            b = sum(bio)) %>% 
  collect()
```

```
## Joining by: "SYNIS_ID"
## Joining by: "SYNIS_ID"
## Joining by: "SYNIS_ID"
## Joining by: "SYNIS_ID"
```

```r
glimpse(cod)
```

```
## Observations: 17,404
## Variables: 4
## $ synis_id (int) 48202, 50764, 48423, 48298, 48283, 47902, 50385, 4822...
## $ ar       (dbl) 1991, 1992, 1991, 1991, 1991, 1991, 1992, 1991, 1991,...
## $ n        (dbl) 563, 28, 236, 106, 189, 43, 86, 45, 244, 7, 1048, 33,...
## $ b        (dbl) 934585.72, 126980.07, 426956.24, 128392.20, 263510.38...
```

```r
cod %>% 
  ggplot(aes(ar, b)) +
  stat_summary(fun.data = "mean_cl_boot", colour = "red") +
  expand_limits(y = 0) +
  labs(x = NULL, y = NULL, title = "Cod: Bootstrap mean biomass and confidence interval") +
  scale_x_continuous(breaks = seq(1985,2015,5))
```

```
## Warning: Removed 396 rows containing non-finite values (stat_summary).
```

![](README_files/figure-html/smb3-1.png)


```r
devtools::session_info()
```

```
## Session info --------------------------------------------------------------
```

```
##  setting  value                       
##  version  R version 3.2.3 (2015-12-10)
##  system   x86_64, linux-gnu           
##  ui       X11                         
##  language (EN)                        
##  collate  is_IS.UTF-8                 
##  tz       Atlantic/Reykjavik          
##  date     2016-04-01
```

```
## Packages ------------------------------------------------------------------
```

```
##  package      * version    date      
##  acepack        1.3-3.3    2014-11-24
##  assertthat     0.1        2013-12-06
##  cluster        2.0.3      2015-07-21
##  colorspace     1.2-6      2015-03-11
##  DBI            0.3.1      2014-09-24
##  devtools       1.10.0     2016-01-23
##  digest         0.6.9      2016-01-08
##  dplyr        * 0.4.3.9001 2016-03-21
##  dplyrOracle  * 0.0.1      2016-03-23
##  evaluate       0.8.3      2016-03-05
##  foreign        0.8-66     2015-08-19
##  formatR        1.3        2016-03-05
##  Formula        1.2-1      2015-04-07
##  ggplot2      * 2.1.0      2016-03-01
##  gisland        0.0.04     2016-03-11
##  gridExtra      2.2.1      2016-02-29
##  gtable         0.2.0      2016-02-26
##  Hmisc          3.17-1     2015-12-18
##  htmltools      0.3.3      2016-02-13
##  knitr          1.12.3     2016-01-22
##  labeling       0.3        2014-08-23
##  lattice        0.20-33    2015-07-14
##  latticeExtra   0.6-28     2016-02-09
##  lazyeval       0.1.10     2015-01-02
##  magrittr       1.5        2014-11-22
##  mapproj        1.2-4      2015-08-03
##  maps           3.1.0      2016-02-13
##  mar          * 0.0.1.9000 2016-04-01
##  memoise        1.0.0      2016-01-29
##  munsell        0.4.3      2016-02-13
##  nnet           7.3-11     2015-08-30
##  plyr           1.8.3      2015-06-12
##  R6             2.1.2      2016-01-26
##  RColorBrewer   1.1-2      2014-12-07
##  Rcpp           0.12.4     2016-03-26
##  rmarkdown      0.9.5      2016-02-22
##  ROracle        1.2-1      2015-07-31
##  rpart          4.1-10     2015-06-29
##  scales         0.4.0      2016-02-26
##  sp           * 1.2-2      2016-02-05
##  stringi        1.0-1      2015-10-22
##  stringr        1.0.0.9000 2016-03-16
##  survival       2.38-3     2015-07-02
##  yaml           2.1.13     2014-06-12
##  source                                     
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.0)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  Github (hadley/dplyr@3bdda9d)              
##  Github (bernardocaldas/dplyrOracle@2841cd9)
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  local                                      
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  Github (rstudio/htmltools@78c5072)         
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  local                                      
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.2)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)                             
##  Github (hadley/stringr@a67f8f0)            
##  CRAN (R 3.2.3)                             
##  CRAN (R 3.2.3)
```

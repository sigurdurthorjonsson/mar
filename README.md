# mar

## dplyr-erized connection to MRI oracle database


```r
# devtools::install_github("hadley/dplyr")
# devtools::install_github("fishvice/dplyrOracle",  dependencies = FALSE)
# devtools::install_github("fishvice/mar",  dependencies = FALSE)
library(dplyr)
library(dplyrOracle)
library(mar)
ls(2)
```

```
##  [1] "afli_afli"        "afli_stofn"       "dst"             
##  [4] "endurheimtur"     "landadur_afli"    "lesa_kvarnir"    
##  [7] "lesa_lengdir"     "lesa_numer"       "lesa_stodvar"    
## [10] "lesa_synaflokka"  "lesa_tegundir"    "lesa_veidarfaeri"
## [13] "lods_oslaegt"     "lods_skipasaga"   "merki"           
## [16] "mfiskar"          "rafaudkenni"      "skipaskra"       
## [19] "taggart"
```

```r
mar <- src_oracle("mar")
d <- lods_oslaegt(mar) %>%
  left_join(skipaskra(mar) %>% select(skip_nr, flokkur), by = "skip_nr") %>% 
  filter(fteg == 1,
         flokkur != -4,
         veidisvaedi == "I") %>%
  group_by(timabil, gerd) %>%
  summarise(afli = sum(magn_oslaegt)) %>%
  arrange(timabil, gerd)
explain(d)
```

```
## <SQL> EXPLAIN PLAN FOR SELECT *
## FROM (SELECT "timabil", "gerd", SUM("magn_oslaegt") AS "afli"
## FROM (SELECT *
## FROM (SELECT * FROM (SELECT "skip_nr", "hofn", "komunr", "l_dags", "gerd", "fteg", "kfteg", "veidisvaedi", "stada", "veidarfaeri", TO_NUMBER(TO_CHAR("l_dags", 'YYYY')) AS "ar", TO_NUMBER(TO_CHAR("l_dags", 'MM')) AS "man", CASE WHEN (TO_NUMBER(TO_CHAR("l_dags", 'MM')) < 9.0) THEN (CONCAT(TO_NUMBER(TO_CHAR("l_dags", 'YYYY')) - 1.0, TO_NUMBER(TO_CHAR("l_dags", 'YYYY')))) ELSE (CONCAT(TO_NUMBER(TO_CHAR("l_dags", 'YYYY')), TO_NUMBER(TO_CHAR("l_dags", 'YYYY')) + 1.0)) END AS "timabil", CASE WHEN ("fteg" IN (30.0, 31.0) AND TO_NUMBER(TO_CHAR("l_dags", 'YYYY')) < 1993.0) THEN ("magn_oslaegt" / 1000.0) ELSE ("magn_oslaegt") END AS "magn_oslaegt"
## FROM (SELECT "skip_nr" AS "skip_nr", "hofn" AS "hofn", "komunr" AS "komunr", "l_dags" AS "l_dags", "gerd" AS "gerd", "fteg" AS "fteg", "kfteg" AS "kfteg", "magn_oslaegt" AS "magn_oslaegt", "veidisvaedi" AS "veidisvaedi", "stada" AS "stada", "veidarf" AS "veidarfaeri"
## FROM (SELECT "SKIP_NR" AS "skip_nr", "HOFN" AS "hofn", "KOMUNR" AS "komunr", "L_DAGS" AS "l_dags", "GERD" AS "gerd", "FTEG" AS "fteg", "KFTEG" AS "kfteg", "MAGN_OSLAEGT" AS "magn_oslaegt", "VEIDISVAEDI" AS "veidisvaedi", "STADA" AS "stada", "VEIDARF" AS "veidarf"
## FROM (kvoti.lods_oslaegt) "pjoxffnqvb") "jzrvhnrdbf") "ofvygaipkj") "bfiubgtxyy"
## 
## LEFT JOIN
## 
## (SELECT "skip_nr" AS "skip_nr", "flokkur" AS "flokkur"
## FROM (SELECT "SKIP_NR" AS "skip_nr", "EINKST" AS "einkst", "EINKNR" AS "einknr", "FLOKKUR" AS "flokkur", "HEIMAH" AS "heimah", "HEITI" AS "heiti", "BRL" AS "brl", "LENGD" AS "lengd", "SIMI" AS "simi", "EIGANDI" AS "eigandi", "REK_ADILI" AS "rek_adili"
## FROM (orri.skipaskra) "fdlnbmntcr") "firocxobqn") "peeozdqweq"
## 
## USING ("skip_nr")) "iopiebqjjp"
## WHERE (("fteg" = 1.0) AND ("flokkur" != -4.0) AND ("veidisvaedi" = 'I'))) "lnkwpblxnr"
## GROUP BY "timabil", "gerd") "obogkewoxs"
## ORDER BY "timabil", "timabil", "gerd"
```

```r
d %>% collect()
```

```
## Source: local data frame [135 x 3]
## Groups: timabil [24]
## 
##     timabil  gerd      afli
##       (chr) (chr)     (dbl)
## 1  19921993     A  -1616591
## 2  19921993     K 203536155
## 3  19921993     L  11160471
## 4  19921993     U   5042948
## 5  19931994     A  -1022178
## 6  19931994     K 168620634
## 7  19931994     L  10463476
## 8  19931994     U   3617187
## 9  19941995     A   -591967
## 10 19941995     K 143869620
## ..      ...   ...       ...
```


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
##  date     2016-04-07
```

```
## Packages ------------------------------------------------------------------
```

```
##  package     * version    date       source                               
##  assertthat    0.1        2013-12-06 CRAN (R 3.2.3)                       
##  DBI           0.3.1      2014-09-24 CRAN (R 3.2.0)                       
##  devtools      1.10.0     2016-01-23 CRAN (R 3.2.3)                       
##  digest        0.6.9      2016-01-08 CRAN (R 3.2.3)                       
##  dplyr       * 0.4.3.9001 2016-03-21 Github (hadley/dplyr@3bdda9d)        
##  dplyrOracle * 0.0.1      2016-04-06 Github (fishvice/dplyrOracle@3644fb7)
##  evaluate      0.8.3      2016-03-05 CRAN (R 3.2.3)                       
##  formatR       1.3        2016-03-05 CRAN (R 3.2.3)                       
##  htmltools     0.3.3      2016-02-13 Github (rstudio/htmltools@78c5072)   
##  knitr         1.12.3     2016-01-22 CRAN (R 3.2.3)                       
##  lazyeval      0.1.10     2015-01-02 CRAN (R 3.2.3)                       
##  magrittr      1.5        2014-11-22 CRAN (R 3.2.3)                       
##  mar         * 0.0.1.9000 2016-04-07 Github (fishvice/mar@dc4d411)        
##  memoise       1.0.0      2016-01-29 CRAN (R 3.2.3)                       
##  R6            2.1.2      2016-01-26 CRAN (R 3.2.3)                       
##  Rcpp          0.12.4     2016-03-26 CRAN (R 3.2.3)                       
##  rmarkdown     0.9.5      2016-02-22 CRAN (R 3.2.3)                       
##  ROracle       1.2-1      2015-07-31 CRAN (R 3.2.2)                       
##  stringi       1.0-1      2015-10-22 CRAN (R 3.2.3)                       
##  stringr       1.0.0.9000 2016-03-16 Github (hadley/stringr@a67f8f0)      
##  yaml          2.1.13     2014-06-12 CRAN (R 3.2.3)
```

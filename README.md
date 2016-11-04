# mar
Bjarki Þór Elvarsson and Einar Hjörleifsson  



<div class="panel panel-warning">
<div class="panel-heading">The small print</div>
<div class="panel-body">

This mar package is work in progress.

</div>
</div>

## Tidyverse connection to MRI oracle database

The [`dplyr`-package](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html) is designed so that, in addition to working with local R-data.frames, it works with remote on-disk data stored in databases. [Inbuilt functions within dplyr](https://cran.rstudio.com/web/packages/dplyr/vignettes/databases.html) allow seamless connectivity with sqlite, mysql and postgresql.

The `dplyrOracle`-package provides a generic connection to Oracle databases. Due to some idiosyncrasies associated with schema as well as issues related to case-sensitivity make "default" communication with Oracle not straight forward. These as well as other convenience wrappers are taken care of in the `mar`-packages.

### Installation

You have to do this once, or when you want to update the packages already installed on your computer:


```r
install.packages("dplyr")
install.packages("devtools")
devtools::install_github("fishvice/dplyrOracle",  dependencies = FALSE)
devtools::install_github("fishvice/mar",  dependencies = FALSE)
```

### Establish conection


```r
library(dplyr)
library(dplyrOracle)
library(mar)
```

Connection to MRI Oracle database:

```r
mar <- src_oracle("mar")
```

### Some (hopefully) gentle introduction
___

The core function in the `mar`-package is the `tbl-mar`-function. It takes two arguments, the "connection" and the name of the oracle table. E.g. to establish a connection to the table "lengdir" in the schema "fiskar" one can do:

```r
lengdir <- tbl_mar(mar, "fiskar.lengdir")
```
What class is lengdir?:

```r
class(lengdir)
```

```
## [1] "tbl_oracle" "tbl_sql"    "tbl_lazy"   "tbl"
```
The class here is somewhat obtuse. Lets not worry about that to much. What has happened behind the scene one can realize by:

```r
explain(lengdir)
```

```
## <SQL> EXPLAIN PLAN FOR SELECT "SYNIS_ID" AS "synis_id", "TEGUND" AS "tegund", "LENGD" AS "lengd", "FJOLDI" AS "fjoldi", "KYN" AS "kyn", "KYNTHROSKI" AS "kynthroski", "SBT" AS "sbt", "SBN" AS "sbn", "SNT" AS "snt", "SNN" AS "snn"
## FROM (fiskar.lengdir) "zjombflqbb"
```
Ergo we generated an object, which one part is an SQL-query. The `explain` informs us how the database plans to execute the query.

The operation has not yet touched the database. It’s not until you ask for the data (e.g. by printing lengdir) that dplyr generates the SQL and requests the results from the database. Even then it only pulls down 10 rows.

```r
lengdir
```

```
## Source:   query [?? x 10]
## Database: Oracle 11.2.0.3.0 [@mar:/mar]
## 
##    synis_id tegund lengd fjoldi   kyn kynthroski                 sbt
##       <int>  <int> <dbl>  <int> <int>      <int>              <dttm>
## 1     48208      1    38      3    NA         NA 1996-08-21 01:00:23
## 2     48208      1    43      2    NA         NA 1996-08-21 01:00:23
## 3     48200      1    13      2    NA         NA 1996-08-21 01:00:23
## 4     48200      1    38      1    NA         NA 1996-08-21 01:00:23
## 5     48200      1    43      1    NA         NA 1996-08-21 01:00:23
## 6     50603     28    23      1    NA         NA 1996-08-21 01:00:14
## 7     50603     28    35      1    NA         NA 1996-08-21 01:00:14
## 8     50604     28    20      2    NA         NA 1996-08-21 01:00:14
## 9     50604     28    21      2    NA         NA 1996-08-21 01:00:14
## 10    50604     28    22      5    NA         NA 1996-08-21 01:00:14
## # ... with more rows, and 3 more variables: sbn <chr>, snt <dttm>,
## #   snn <chr>
```
Now, there are columns returned that we have little interest in (sbt:snn). Using the `dplyr`-verbs (functions) one can easily build upon the base query, e.g.:

```r
lengdir %>% 
  select(synis_id, tegund, lengd, fjoldi, kyn, kynthroski) %>% 
  glimpse()
```

```
## Observations: NA
## Variables: 6
## $ synis_id   <int> 48208, 48208, 48200, 48200, 48200, 50603, 50603, 50...
## $ tegund     <int> 1, 1, 1, 1, 1, 28, 28, 28, 28, 28, 28, 28, 28, 28, ...
## $ lengd      <dbl> 38, 43, 13, 38, 43, 23, 35, 20, 21, 22, 24, 25, 26,...
## $ fjoldi     <int> 3, 2, 2, 1, 1, 1, 1, 2, 2, 5, 4, 8, 5, 2, 3, 7, 5, ...
## $ kyn        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
## $ kynthroski <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
```

Now if one were only interested in one species and one station we may extend the above as:

```r
lengdir <- 
  tbl_mar(mar, "fiskar.lengdir") %>% 
  select(synis_id, tegund, lengd, fjoldi, kyn, kynthroski) %>% 
  filter(synis_id == 48489,
         tegund == 1)
explain(lengdir)
```

```
## <SQL> EXPLAIN PLAN FOR SELECT *
## FROM (SELECT "synis_id" AS "synis_id", "tegund" AS "tegund", "lengd" AS "lengd", "fjoldi" AS "fjoldi", "kyn" AS "kyn", "kynthroski" AS "kynthroski"
## FROM (SELECT "SYNIS_ID" AS "synis_id", "TEGUND" AS "tegund", "LENGD" AS "lengd", "FJOLDI" AS "fjoldi", "KYN" AS "kyn", "KYNTHROSKI" AS "kynthroski", "SBT" AS "sbt", "SBN" AS "sbn", "SNT" AS "snt", "SNN" AS "snn"
## FROM (fiskar.lengdir) "ifeuaahoxy") "ikddsoheux") "ikyejjhpoj"
## WHERE (("synis_id" = 48489.0) AND ("tegund" = 1.0))
```

To pull down all the results into R one uses collect(), which returns a tidyverse data.frame (tbl_df):

```r
d <- 
  lengdir %>% 
  collect()
class(d)
```

```
## [1] "tbl_df"     "tbl"        "data.frame"
```

```r
dim(d)
```

```
## [1] 31  6
```

A quick visualization of the data can be obtained via:

```r
library(ggplot2)
d %>% 
  ggplot() +
  geom_bar(aes(lengd, fjoldi), stat = "identity")
```

![](README_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

So we have the length distribution of measured cod from one sample (station). We do not however know what this sample is, because the column **synis_id** is just some gibberish automatically generated within Oracle. Before we deal with that, lets introduce `lesa_lengdir`-function that resides in the `mar`-package:


```r
lesa_lengdir(mar) %>% glimpse()
```

```
## Observations: NA
## Variables: 7
## $ synis_id        <int> 47967, 47761, 47619, 47961, 50662, 50671, 5067...
## $ tegund          <int> 1, 1, 1, 2, 9, 8, 8, 8, 1, 2, 2, 2, 2, 2, 8, 2...
## $ lengd           <dbl> 14, 66, 86, 71, 21, 23, 46, 31, 45, 57, 15, 35...
## $ fjoldi          <int> 1, 5, 2, 1, 1, 1, 1, 1, 1, 2, 6, 33, 1, 1, 1, ...
## $ kyn             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ kynthroski      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
## $ uppruni_lengdir <chr> "lengdir", "lengdir", "lengdir", "lengdir", "l...
```

Here we have same columns as above with one additional column, **uppruni_lengdir**. This is because the function reads from two different tables, **fiskar.lengdir** and **fiskar.leidr_lengdir** and combines them into one. Hopefully this is only an interim measure - there are plans to merge these two data tables into one (lets keep our fingers crossed). 

Lets used `lesa_lengdir` as our starting point, this time lets ask the question how many fish by species were length measured from this yet unknown station:

```r
d <-
  lesa_lengdir(mar) %>% 
  filter(synis_id == 48489) %>% 
  group_by(tegund) %>% 
  summarise(fjoldi = sum(fjoldi)) %>% 
  arrange(fjoldi)
explain(d)
```

```
## <SQL> EXPLAIN PLAN FOR SELECT *
## FROM (SELECT "tegund", SUM("fjoldi") AS "fjoldi"
## FROM (SELECT *
## FROM (SELECT DISTINCT *
## FROM (SELECT "synis_id", "tegund", "lengd", "fjoldi", "kyn", "kynthroski", 'lengdir' AS "uppruni_lengdir"
## FROM (SELECT "synis_id" AS "synis_id", "tegund" AS "tegund", "lengd" AS "lengd", "fjoldi" AS "fjoldi", "kyn" AS "kyn", "kynthroski" AS "kynthroski"
## FROM (SELECT * FROM (SELECT "SYNIS_ID" AS "synis_id", "TEGUND" AS "tegund", "LENGD" AS "lengd", "FJOLDI" AS "fjoldi", "KYN" AS "kyn", "KYNTHROSKI" AS "kynthroski", "SBT" AS "sbt", "SBN" AS "sbn", "SNT" AS "snt", "SNN" AS "snn"
## FROM (fiskar.lengdir) "xwomwhqybe") "yiefzunjeu"
## 
## INNER JOIN
## 
## (SELECT "synis_id" AS "synis_id"
## FROM (SELECT *
## FROM (SELECT "SYNIS_ID" AS "synis_id", "LEIDANGUR" AS "leidangur", "DAGS" AS "dags", "SKIP" AS "skip", "STOD" AS "stod", "REITUR" AS "reitur", "SMAREITUR" AS "smareitur", "KASTAD_N_BREIDD" AS "kastad_n_breidd", "KASTAD_V_LENGD" AS "kastad_v_lengd", "HIFT_N_BREIDD" AS "hift_n_breidd", "HIFT_V_LENGD" AS "hift_v_lengd", "DYPI_KASTAD" AS "dypi_kastad", "DYPI_HIFT" AS "dypi_hift", "VEIDARFAERI" AS "veidarfaeri", "MOSKVASTAERD" AS "moskvastaerd", "GRANDARALENGD" AS "grandaralengd", "HEILDARAFLI" AS "heildarafli", "LONDUNARHOFN" AS "londunarhofn", "SKIKI" AS "skiki", "FJARDARREITUR" AS "fjardarreitur", "SNT" AS "snt", "SNN" AS "snn", "SBT" AS "sbt", "SBN" AS "sbn", "HNATTSTADA" AS "hnattstada", "LANDSYNI" AS "landsyni", "ATHS" AS "aths", "STADA_STODVAR" AS "stada_stodvar", "NET_NR" AS "net_nr", "SYNAFLOKKUR" AS "synaflokkur", "VEIDISVAEDI" AS "veidisvaedi", "HITAMAELIR_ID" AS "hitamaelir_id", "MAELINGARMENN" AS "maelingarmenn", "VEIDARFAERI_ID" AS "veidarfaeri_id", "TOG_ATHS" AS "tog_aths", "MEDFERD_AFLA" AS "medferd_afla"
## FROM (fiskar.stodvar) "uwwuiohxrs") "fmlbrolffu"
## WHERE ("dags" > TO_DATE('01.01.1986', 'dd.mm.yyyy'))) "zziygxmlne") "obtmwgaomy"
## 
## USING ("synis_id")) "epxxhhvqfl") "fvibupdenv"
## UNION ALL
## SELECT "synis_id", "tegund", "lengd", "fjoldi", "kyn", "kynthroski", 'leidr_lengdir' AS "uppruni_lengdir"
## FROM (SELECT *
## FROM (SELECT * FROM (SELECT "synis_id" AS "synis_id", "tegund" AS "tegund", "lengd" AS "lengd", "fjoldi" AS "fjoldi", "kyn" AS "kyn", "kynthroski" AS "kynthroski"
## FROM (SELECT "SNT" AS "snt", "SNN" AS "snn", "SBT" AS "sbt", "SBN" AS "sbn", "SYNIS_ID" AS "synis_id", "TEGUND" AS "tegund", "LENGD" AS "lengd", "FJOLDI" AS "fjoldi", "KYN" AS "kyn", "KYNTHROSKI" AS "kynthroski"
## FROM (fiskar.leidr_lengdir) "rihbsdiitw") "zpiwgthfkg") "jtszbzzblu"
## 
## INNER JOIN
## 
## (SELECT "synis_id" AS "synis_id"
## FROM (SELECT *
## FROM (SELECT "SNT" AS "snt", "SNN" AS "snn", "SBT" AS "sbt", "SBN" AS "sbn", "SYNIS_ID" AS "synis_id", "LEIDANGUR" AS "leidangur", "SYNAFLOKKUR" AS "synaflokkur", "DAGS" AS "dags", "SKIP_NR" AS "skip_nr", "STOD" AS "stod", "REITUR" AS "reitur", "SMAREITUR" AS "smareitur", "ORREITUR" AS "orreitur", "HNATTSTADA" AS "hnattstada", "KASTAD_BREIDD" AS "kastad_breidd", "KASTAD_LENGD" AS "kastad_lengd", "HIFT_BREIDD" AS "hift_breidd", "HIFT_LENGD" AS "hift_lengd", "DYPI_KASTAD" AS "dypi_kastad", "DYPI_HIFT" AS "dypi_hift", "VEIDARF" AS "veidarf", "MOSKVASTAERD" AS "moskvastaerd", "GRANDARALENGD" AS "grandaralengd", "HEILDARAFLI" AS "heildarafli", "L_HOFN" AS "l_hofn", "SKIKI" AS "skiki", "FJ_REITUR" AS "fj_reitur", "TOGBYRJUN" AS "togbyrjun", "TOGENDIR" AS "togendir", "TOGHRADI" AS "toghradi", "TOGLENGD" AS "toglengd", "VIR_UTI" AS "vir_uti", "LODRETT_OPNUN" AS "lodrett_opnun", "TOGNUMER" AS "tognumer", "TOGSTEFNA" AS "togstefna", "LARETT_OPNUN" AS "larett_opnun", "TOGTIMI" AS "togtimi", "EYKT" AS "eykt", "TOGDYPI_KASTAD" AS "togdypi_kastad", "TOGDYPI_HIFT" AS "togdypi_hift", "TOGDYPISHITI" AS "togdypishiti", "VINDHRADI" AS "vindhradi", "VINDATT" AS "vindatt", "VEDUR" AS "vedur", "SKY" AS "sky", "SJOR" AS "sjor", "BOTNHITI" AS "botnhiti", "YFIRB_HITI" AS "yfirb_hiti", "LOFTHITI" AS "lofthiti", "LOFTVOG" AS "loftvog", "HAFIS" AS "hafis", "STRAUMSTEFNA" AS "straumstefna", "STRAUMHRADI" AS "straumhradi", "SJONDYPI" AS "sjondypi", "ATHS" AS "aths", "LANDSYNI" AS "landsyni", "STADA_STODVAR" AS "stada_stodvar", "HITAMAELIR_ID" AS "hitamaelir_id", "MAELINGARMENN" AS "maelingarmenn", "MEDFERD_AFLA" AS "medferd_afla", "NET_NR" AS "net_nr", "TOG_ATHS" AS "tog_aths", "VEIDARFAERI_ID" AS "veidarfaeri_id", "VEIDISVAEDI" AS "veidisvaedi", "VINDHRADI_HNUTAR" AS "vindhradi_hnutar"
## FROM (fiskar.leidr_stodvar) "boxoxgrxhh") "ctpspxwqms"
## WHERE ("dags" < TO_DATE('01.01.1986', 'dd.mm.yyyy') AND "dags" > TO_DATE('1910', 'yyyy'))) "oribppffxi") "qlvaxqimzg"
## 
## USING ("synis_id")) "qstbubnwuj"
## WHERE (NOT(("synis_id" IN (133095.0, 57070.0, 133401.0, 37559.0, 112980.0, 112984.0, 112987.0, 112991.0, 112995.0, 112998.0, 112999.0, 128268.0, 129166.0, 129168.0, 140153.0, 140155.0, 129370.0, 129170.0, 128765.0, 129098.0, 119798.0, 128890.0, 129146.0, 128586.0, 128898.0, 128902.0, 123916.0, 128392.0, 116665.0, 115948.0, 115967.0))))) "rmwofvcxyp") "euaokkmyqy") "jmrrlryoet"
## WHERE ("synis_id" = 48489.0)) "qiscljfgsr"
## GROUP BY "tegund") "frhpkjcwrd"
## ORDER BY "fjoldi"
```

The SQL query has now become a bunch of gibberish for some of us. But this demonstrates that in addition to **select** and **filter** the `dplyr`-verbs **group_by**, **summarise** and **arrange** are "translated" into SQL :-) To see the outcome we do:

```r
d %>% collect()
```

```
## # A tibble: 7 × 2
##   tegund fjoldi
##    <int>  <dbl>
## 1      2      1
## 2     25      6
## 3     22      6
## 4      5     39
## 5     12     49
## 6     28     60
## 7      1    119
```

Those familiar with the fiskar database know that these information are also available in the table **numer**. Here we can use the ``mar::lesa_numer` function:

```r
# BUG, not run
lesa_numer(mar) %>% 
  filter(synis_id == 48489)
```


```r
tbl_mar(mar, "fiskar.numer") %>% 
  filter(synis_id == 48489) %>% 
  select(tegund, fj_maelt, fj_talid) %>% 
  arrange(fj_maelt) %>% 
  collect()
```

```
## # A tibble: 11 × 3
##    tegund fj_maelt fj_talid
##     <int>    <int>    <int>
## 1      85        0      123
## 2      53        0        1
## 3      30        0       11
## 4      56        0        2
## 5       2        1        0
## 6      22        6        0
## 7      25        6        0
## 8       5       39        0
## 9      12       49        0
## 10     28       60        0
## 11      1      119        0
```

So we get a dataframe that has more species than those obtained from `lesa_lengdir`. This is because the sample (station) also contained some species that were not measured, only counted.

Information about the station that corresponds to synis_id = 48489 reside in the station table:

```r
lesa_stodvar(mar) %>% 
  filter(synis_id == 48489) %>% 
  glimpse()
```

```
## Observations: NA
## Variables: 65
## $ synis_id         <int> 48489
## $ leidangur        <chr> "TA1-91"
## $ dags             <dttm> 1991-03-06
## $ skip             <int> 1307
## $ stod             <int> 9
## $ reitur           <int> 669
## $ smareitur        <int> 4
## $ kastad_n_breidd  <int> 663055
## $ kastad_v_lengd   <int> 192363
## $ hift_n_breidd    <int> 663345
## $ hift_v_lengd     <int> 192272
## $ dypi_kastad      <int> 311
## $ dypi_hift        <int> 311
## $ veidarfaeri      <int> 73
## $ moskvastaerd     <int> 40
## $ grandaralengd    <int> 45
## $ heildarafli      <int> NA
## $ londunarhofn     <int> NA
## $ skiki            <int> NA
## $ fjardarreitur    <int> NA
## $ hnattstada       <int> -1
## $ landsyni         <dbl> 0
## $ aths_stodvar     <chr> NA
## $ stada_stodvar    <int> NA
## $ net_nr           <int> NA
## $ synaflokkur      <dbl> 30
## $ veidisvaedi      <chr> NA
## $ hitamaelir_id    <dbl> NA
## $ maelingarmenn    <chr> NA
## $ veidarfaeri_id   <dbl> NA
## $ tog_aths         <chr> NA
## $ medferd_afla     <int> NA
## $ togbyrjun        <dttm> 1991-03-06 17:12:00
## $ togendir         <dttm> 1991-03-06 18:03:00
## $ toghradi         <dbl> 3.5
## $ toglengd         <dbl> 3
## $ vir_uti          <int> 375
## $ lodrett_opnun    <dbl> 2.2
## $ tognumer         <dbl> 11
## $ togstefna        <int> 15
## $ larett_opnun     <dbl> NA
## $ togtimi          <dbl> 51
## $ togdypi_kastad   <int> NA
## $ togdypi_hift     <int> NA
## $ togdypishiti     <dbl> NA
## $ eykt             <int> NA
## $ tog_lengd        <dbl> NA
## $ dregid_fra       <chr> NA
## $ vindhradi        <int> 5
## $ vindatt          <int> 5
## $ vedur            <int> 1
## $ sky              <int> 7
## $ sjor             <int> 2
## $ botnhiti         <dbl> 4
## $ yfirbordshiti    <dbl> 3.5
## $ lofthiti         <dbl> 2.5
## $ loftvog          <int> 1006
## $ hafis            <int> 0
## $ straumstefna     <int> NA
## $ straumhradi      <dbl> NA
## $ sjondypi         <int> NA
## $ vindhradi_hnutar <int> 9
## $ uppruni_stodvar  <chr> "stodvar"
## $ ar               <dbl> 1991
## $ man              <dbl> 3
```

For those familiar with what is stored in **fiskar.stodvar** recognize that the station is most likely part of the 1991 spring survey (veidarfaeri = 73 and synaflokkur = 30 provides the best hint). What if we were to start from this end and get all the stations from the 1991 survey and also limit the number of columns returned:

```r
smb1991 <-
  lesa_stodvar(mar) %>% 
  filter(ar == 1991,
         veidarfaeri == 73,
         synaflokkur == 30) %>% 
  select(synis_id,
         lon = kastad_v_lengd,
         lat = kastad_n_breidd)
```

To get a quick plot of the station location we could do:

```r
smb1991 %>% 
  collect() %>% 
  # convert ddmmxx to decimal degrees
  mutate(lon = -gisland::geo_convert(lon),
         lat =  gisland::geo_convert(lat)) %>% 
  ggplot(aes(lon, lat)) +
  geom_polygon(data = gisland::iceland, aes(long, lat, group = group)) +
  geom_point(col = "red") +
  coord_quickmap()
```

![](README_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

Looks about right. But what if we were interested in getting the total number of fish recorded at each station? Here we need to obtain the information from **fiskar.numer** for the station (synis_id) in question. This we do by using `left_join`:

```r
nu <- 
  tbl_mar(mar, "fiskar.numer") %>% 
  group_by(synis_id) %>% 
  summarise(n = sum(fj_maelt + fj_talid))
smb1991_n <-
  smb1991 %>% 
  left_join(nu)
```

Again we have not done much more than generate an SQL-query and not touched the database. For those interested seeing the SQL-code do:

```r
explain(smb1991_n)
```

To turn this into action, lets execute the query, get the dataframe into R and plot the data:

```r
smb1991_n %>% 
  collect() %>% 
  mutate(lon = -gisland::geo_convert(lon),
         lat =  gisland::geo_convert(lat)) %>% 
  ggplot() +
  theme_bw() +
  geom_polygon(data = gisland::iceland, aes(long, lat, group = group), fill = "grey") +
  geom_point(aes(lon, lat, size = n), col = "red", alpha = 0.25) +
  scale_size_area(max_size = 15) +
  scale_x_continuous(NULL, NULL) +
  scale_y_continuous(NULL, NULL) +
  coord_quickmap()
```

![](README_files/figure-html/unnamed-chunk-22-1.png)<!-- -->




### Something else (more advanced)
____

... pending

### Working with stomach data
____

... pending


```r
devtools::session_info()
```

```
##  setting  value                       
##  version  R version 3.3.1 (2016-06-21)
##  system   x86_64, linux-gnu           
##  ui       X11                         
##  language (EN)                        
##  collate  is_IS.UTF-8                 
##  tz       Atlantic/Reykjavik          
##  date     2016-11-04                  
## 
##  package     * version    date      
##  assertthat    0.1        2013-12-06
##  colorspace    1.2-6      2015-03-11
##  data.table    1.9.7      2016-10-25
##  DBI           0.5-1      2016-09-10
##  devtools      1.12.0     2016-06-24
##  digest        0.6.10     2016-08-02
##  dplyr       * 0.5.0      2016-06-24
##  dplyrOracle * 0.0.1      2016-11-04
##  evaluate      0.8        2015-09-18
##  formatR       1.2.1      2015-09-18
##  ggplot2     * 2.1.0      2016-03-01
##  gisland       0.0.05     2016-10-25
##  gtable        0.2.0      2016-02-26
##  htmltools     0.3.5      2016-03-21
##  knitr         1.14       2016-08-13
##  labeling      0.3        2014-08-23
##  lattice       0.20-27    2014-02-27
##  lazyeval      0.2.0      2016-06-12
##  magrittr      1.5        2014-11-22
##  mar         * 0.0.3.9000 2016-11-04
##  memoise       1.0.0      2016-01-29
##  munsell       0.4.3      2016-02-13
##  plyr          1.8.4      2016-06-08
##  R6            2.2.0      2016-10-05
##  Rcpp          0.12.7     2016-09-05
##  rmarkdown     1.1        2016-10-16
##  ROracle       1.2-2      2016-02-17
##  scales        0.4.0      2016-02-26
##  sp          * 1.2-3      2016-04-14
##  stringi       1.1.1      2016-05-27
##  stringr       1.1.0      2016-08-19
##  tibble        1.2        2016-08-26
##  withr         1.0.2      2016-06-20
##  yaml          2.1.13     2014-06-12
##  source                                    
##  CRAN (R 3.0.2)                            
##  CRAN (R 3.2.0)                            
##  Github (Rdatatable/data.table@8c9cfc8)    
##  cran (@0.5-1)                             
##  CRAN (R 3.3.1)                            
##  cran (@0.6.10)                            
##  CRAN (R 3.3.1)                            
##  Github (fishvice/dplyrOracle@3230705)     
##  CRAN (R 3.2.3)                            
##  CRAN (R 3.2.3)                            
##  CRAN (R 3.3.1)                            
##  Github (einarhjorleifsson/gisland@53f5a1f)
##  cran (@0.2.0)                             
##  CRAN (R 3.3.0)                            
##  CRAN (R 3.3.1)                            
##  CRAN (R 3.2.0)                            
##  CRAN (R 3.0.2)                            
##  cran (@0.2.0)                             
##  CRAN (R 3.1.2)                            
##  Github (fishvice/mar@15f3849)             
##  CRAN (R 3.3.0)                            
##  cran (@0.4.3)                             
##  cran (@1.8.4)                             
##  cran (@2.2.0)                             
##  cran (@0.12.7)                            
##  CRAN (R 3.3.1)                            
##  CRAN (R 3.3.0)                            
##  cran (@0.4.0)                             
##  cran (@1.2-3)                             
##  cran (@1.1.1)                             
##  CRAN (R 3.3.0)                            
##  cran (@1.2)                               
##  CRAN (R 3.3.0)                            
##  CRAN (R 3.2.1)
```

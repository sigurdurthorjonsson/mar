---
title: "mar"
author: Bjarki Þór Elvarsson and Einar Hjörleifsson
output: 
  html_document: 
    keep_md: yes
---



The small print: Package in the making

## Tidyverse connection to MRI oracle database

The [`dplyr`-package](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html) is designed so that, in addition to working with local R-data.frames, it works with remote on-disk data stored in databases. [Inbuilt functions within dplyr](https://cran.rstudio.com/web/packages/dplyr/vignettes/databases.html) allow seamless connectivity with sqlite, mysql and postgresql. Due to some idiosyncrasies associated with schema as well as issues related to case-sensitivity make "default" communication with Oracle not straight forward. These as well as other convenience wrappers are taken care of in the `mar`-packages.

### Installation

You have to do this once, or when you want to update the packages already installed on your computer:


```r
install.packages("tidyverse")
install.packages("devtools")
devtools::install_github("tidyverse/dbplyr")
devtools::install_github("fishvice/mar",  dependencies = FALSE)
```

Windows users may encounter issues when installing the mar - package related to different binary modes (32 bit vs 64 bit) where the user is prompted with the following error 

> ERROR: loading failed for 'i386'

This issue can be bypassed by installing mar using: 

```r
devtools::install_github("fishvice/mar",  dependencies = FALSE, args='--no-multiarch')
```


### Establish connection


```r
library(tidyverse)
library(ROracle)
library(mar)
```

Connection to MRI Oracle database:

```r
con <- connect_mar()
```

### Some (hopefully) gentle introduction
___

The core function in the `mar`-package is the `tbl-mar`-function. It takes two arguments, the "connection" and the name of the oracle table. E.g. to establish a connection to the table "lengdir" in the schema "fiskar" one can do:

```r
lengdir <- tbl_mar(con, "fiskar.lengdir")
```
What class is lengdir?:

```r
class(lengdir)
```

```
## [1] "tbl_dbi"  "tbl_sql"  "tbl_lazy" "tbl"
```
The class here is somewhat obtuse. Lets not worry about that to much. What has happened behind the scene one can realize by:

```r
show_query(lengdir) 
```
Ergo we generated an object, which one part is an SQL-query. The `show_query` informs us how the database plans to execute the query.

The operation has not yet touched the database. It’s not until you ask for the data (e.g. by printing lengdir) that dplyr generates the SQL and requests the results from the database. Even then it only pulls down 10 rows.

```r
lengdir
```

```
## # Source:   lazy query [?? x 10]
## # Database: OraConnection
##    synis_id tegund lengd fjoldi   kyn kynthroski                 sbt
##       <int>  <int> <dbl>  <int> <int>      <int>              <dttm>
##  1    48208      1    38      3    NA         NA 1996-08-21 01:00:23
##  2    48208      1    43      2    NA         NA 1996-08-21 01:00:23
##  3    48200      1    13      2    NA         NA 1996-08-21 01:00:23
##  4    48200      1    38      1    NA         NA 1996-08-21 01:00:23
##  5    48200      1    43      1    NA         NA 1996-08-21 01:00:23
##  6    50603     28    23      1    NA         NA 1996-08-21 01:00:14
##  7    50603     28    35      1    NA         NA 1996-08-21 01:00:14
##  8    50604     28    20      2    NA         NA 1996-08-21 01:00:14
##  9    50604     28    21      2    NA         NA 1996-08-21 01:00:14
## 10    50604     28    22      5    NA         NA 1996-08-21 01:00:14
## # ... with more rows, and 3 more variables: sbn <chr>, snt <dttm>,
## #   snn <chr>
```
Now, there are columns returned that we have little interest in (sbt:snn). Using the `dplyr`-verbs (functions) one can easily build upon the base query, e.g.:

```r
lengdir %>% 
  select(synis_id, tegund, lengd, fjoldi, kyn, kynthroski)
```

```
## # Source:   lazy query [?? x 6]
## # Database: OraConnection
##    synis_id tegund lengd fjoldi   kyn kynthroski
##       <int>  <int> <dbl>  <int> <int>      <int>
##  1    48208      1    38      3    NA         NA
##  2    48208      1    43      2    NA         NA
##  3    48200      1    13      2    NA         NA
##  4    48200      1    38      1    NA         NA
##  5    48200      1    43      1    NA         NA
##  6    50603     28    23      1    NA         NA
##  7    50603     28    35      1    NA         NA
##  8    50604     28    20      2    NA         NA
##  9    50604     28    21      2    NA         NA
## 10    50604     28    22      5    NA         NA
## # ... with more rows
```

Now if one were only interested in one species and one station we may extend the above as:

```r
lengdir <- 
  tbl_mar(con, "fiskar.lengdir") %>% 
  select(synis_id, tegund, lengd, fjoldi, kyn, kynthroski) %>% 
  filter(synis_id == 48489,
         tegund == 1)
show_query(lengdir)
```

To pull down all the results into R one uses collect(), which returns a tidyverse data.frame (tbl_df):

```r
d <- 
  lengdir %>% 
  collect(n = Inf)
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
d %>% 
  ggplot() +
  geom_bar(aes(lengd, fjoldi), stat = "identity")
```

![](README_files/figure-html/ldist-1.png)<!-- -->

So we have the length distribution of measured cod from one sample (station). We do not however know what this sample is, because the column **synis_id** is just some gibberish automatically generated within Oracle. Before we deal with that, lets introduce `lesa_lengdir`-function that resides in the `mar`-package:


```r
lesa_lengdir(con)
```

```
## # Source:   lazy query [?? x 6]
## # Database: OraConnection
##    synis_id tegund lengd fjoldi   kyn kynthroski
##       <int>  <int> <dbl>  <int> <int>      <int>
##  1    48208      1    38      3    NA         NA
##  2    48208      1    43      2    NA         NA
##  3    48200      1    13      2    NA         NA
##  4    48200      1    38      1    NA         NA
##  5    48200      1    43      1    NA         NA
##  6    50603     28    23      1    NA         NA
##  7    50603     28    35      1    NA         NA
##  8    50604     28    20      2    NA         NA
##  9    50604     28    21      2    NA         NA
## 10    50604     28    22      5    NA         NA
## # ... with more rows
```

Here we have same columns as above with one additional column, **uppruni_lengdir**. This is because the function reads from two different tables, **fiskar.lengdir** and **fiskar.leidr_lengdir** and combines them into one. Hopefully this is only an interim measure - there are plans to merge these two data tables into one (lets keep our fingers crossed). 

Lets used `lesa_lengdir` as our starting point, this time lets ask the question how many fish by species were length measured from this yet unknown station:

```r
d <-
  lesa_lengdir(con) %>% 
  filter(synis_id == 48489) %>% 
  group_by(tegund) %>% 
  summarise(fjoldi = sum(fjoldi)) %>% 
  arrange(fjoldi)
show_query(d)
```

The SQL query has now become a bunch of gibberish for some of us. But this demonstrates that in addition to **select** and **filter** the `dplyr`-verbs **group_by**, **summarise** and **arrange** are "translated" into SQL :-) To see the outcome we do:

```r
d %>% collect(n = Inf)
```

```
## # A tibble: 7 x 2
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
lesa_numer(con) %>% 
  filter(synis_id == 48489)
```

```
## # Source:   lazy query [?? x 19]
## # Database: OraConnection
##    synis_id tegund fj_maelt fj_kvarnad gamalt_lnr gamalt_knr fj_talid
##       <int>  <int>    <int>      <int>      <int>      <int>    <int>
##  1    48489      1      119         56        209        209        0
##  2    48489      2        1          1        208        208        0
##  3    48489      5       39          0        209         NA        0
##  4    48489     12       49          0        209         NA        0
##  5    48489     22        6          0        202         NA        0
##  6    48489     25        6          0        203         NA        0
##  7    48489     28       60          0        209         NA        0
##  8    48489     30        0          0         NA         NA       11
##  9    48489     53        0          0         NA         NA        1
## 10    48489     56        0          0         NA         NA        2
## # ... with more rows, and 12 more variables: afli <dbl>,
## #   fj_kyngreint <int>, fj_vigtad <int>, vigt_synis <dbl>,
## #   fj_magasyna <int>, aths_numer <chr>, status_lengdir <int>,
## #   status_kvarnir <int>, fj_merkt <int>, fj_aldursgr <int>,
## #   kg_talning <int>, uppruni_numer <chr>
```


```r
tbl_mar(con, "fiskar.numer") %>% 
  filter(synis_id == 48489) %>% 
  select(tegund, fj_maelt, fj_talid) %>% 
  arrange(fj_maelt) %>% 
  collect(n = Inf)
```

```
## # A tibble: 11 x 3
##    tegund fj_maelt fj_talid
##     <int>    <int>    <int>
##  1     85        0      123
##  2     53        0        1
##  3     30        0       11
##  4     56        0        2
##  5      2        1        0
##  6     22        6        0
##  7     25        6        0
##  8      5       39        0
##  9     12       49        0
## 10     28       60        0
## 11      1      119        0
```

So we get a dataframe that has more species than those obtained from `lesa_lengdir`. This is because the sample (station) also contained some species that were not measured, only counted.

Information about the station that corresponds to synis_id = 48489 reside in the station table:

```r
lesa_stodvar(con) %>% 
  filter(synis_id == 48489) %>% 
  collect() %>% 
  glimpse()
```

```
## Observations: 1
## Variables: 64
## $ synis_id         <int> 48489
## $ leidangur        <chr> "TA1-91"
## $ dags             <dttm> 1991-03-06
## $ skip             <int> 1307
## $ ar               <dbl> 1991
## $ man              <dbl> 3
## $ stod             <int> 9
## $ reitur           <dbl> 669
## $ smareitur        <dbl> 4
## $ kastad_n_breidd  <dbl> 66.50917
## $ kastad_v_lengd   <dbl> -19.39383
## $ hift_n_breidd    <dbl> 66.5575
## $ hift_v_lengd     <dbl> -19.37867
## $ dypi_kastad      <int> 311
## $ dypi_hift        <int> 311
## $ veidarfaeri      <int> 73
## $ moskvastaerd     <int> 40
## $ grandarlengd     <int> 45
## $ heildarafli      <int> NA
## $ londunarhofn     <int> NA
## $ skiki            <int> NA
## $ fjardarreitur    <int> NA
## $ hnattstada       <int> -1
## $ landsyni         <int> 0
## $ aths_stodvar     <chr> NA
## $ stada_stodvar    <int> NA
## $ net_nr           <int> NA
## $ synaflokkur      <int> 30
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
## $ tognumer         <int> 11
## $ togstefna        <int> 15
## $ larett_opnun     <dbl> NA
## $ togtimi          <int> 51
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
```

For those familiar with what is stored in **fiskar.stodvar** recognize that the station is most likely part of the 1991 spring survey (veidarfaeri = 73 and synaflokkur = 30 provides the best hint). What if we were to start from this end and get all the stations from the 1991 survey and also limit the number of columns returned:

```r
smb1991 <-
  lesa_stodvar(con) %>% 
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
  collect(n = Inf) %>% 
  ggplot(aes(lon, lat)) +
  geom_polygon(data = gisland::iceland, aes(long, lat, group = group)) +
  geom_point(col = "red") +
  coord_quickmap()
```

![](README_files/figure-html/smb1991_stodvar-1.png)<!-- -->

Looks about right. But what if we were interested in getting the total number of fish recorded at each station? Here we need to obtain the information from **fiskar.numer** for the station (synis_id) in question. This we do by using `left_join`:

```r
nu <- 
  tbl_mar(con, "fiskar.numer") %>% 
  group_by(synis_id) %>% 
  summarise(n = sum(fj_maelt + fj_talid))
smb1991_n <-
  smb1991 %>% 
  left_join(nu)
```

Again we have not done much more than generate an SQL-query and not touched the database. For those interested seeing the SQL-code do:

```r
show_query(smb1991_n)
```

To turn this into action, lets execute the query, get the dataframe into R and plot the data:

```r
smb1991_n %>% 
  collect(n = Inf) %>% 
  ggplot() +
  theme_bw() +
  geom_polygon(data = gisland::iceland, aes(long, lat, group = group), fill = "grey") +
  geom_point(aes(lon, lat, size = n), col = "red", alpha = 0.25) +
  scale_size_area(max_size = 15) +
  scale_x_continuous(NULL, NULL) +
  scale_y_continuous(NULL, NULL) +
  coord_quickmap()
```

![](README_files/figure-html/smb1991_n-1.png)<!-- -->



### Metadata

List of tables available to the user:

```r
mar_tables(con, schema = 'fiskar') %>% knitr::kable()
```



owner    table_name               tablespace_name    num_rows  last_analyzed         table_type   comments                                                                                                                                                                                                                                                      
-------  -----------------------  ----------------  ---------  --------------------  -----------  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FISKAR   REITIR                   NYT                    2864  2017-10-12 22:00:15   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   KVARNALOGUN              NYT                     801  2017-11-17 22:00:17   TABLE        Tafla fyrir greiningu á lögun kvarna.                                                                                                                                                                                                                         
FISKAR   BEITA                    NYT                       2  2017-06-28 11:32:50   TABLE        Ekki beit/beita.  tengt túnfisks ransóknum                                                                                                                                                                                                                    
FISKAR   BOX                      NYT                   29833  2017-10-17 22:00:45   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   FLOKKAR                  NYT                       0  2017-06-28 11:35:33   TABLE        Tengt fiskflokkurum (vilhal)                                                                                                                                                                                                                                  
FISKAR   FLOKKAR_SENDINGAR        NYT                   13527  2017-06-28 11:35:33   TABLE        Tengt fiskflokkurum (vilhal)                                                                                                                                                                                                                                  
FISKAR   G_TROSSUR                NYT                     222  2017-06-28 11:47:35   TABLE        Nöfn á veiðislóðum vegna netaralls.                                                                                                                                                                                                                           
FISKAR   G_VIKMORK                NYT                     253  2017-06-28 11:47:36   TABLE        Tengt villuleitinni.  skoða view fiskar.vikmork                                                                                                                                                                                                               
FISKAR   HAFIS                    NYT                      10  2017-06-28 11:47:42   TABLE        Uppflettitafla umhverfisþátta. Hafískóðar og lýsingar. LYKILL: hafis                                                                                                                                                                                          
FISKAR   ICES_TEGUNDIR            NYT                      21  2017-06-28 11:48:32   TABLE        ices fisktengurndir á ensku                                                                                                                                                                                                                                   
FISKAR   INNSLATT_STATUS          NYT                      17  2017-06-28 11:48:50   TABLE        Gamall insláttar status fyrir lengdir, kvarnir og stöðvar                                                                                                                                                                                                     
FISKAR   INNYFLAFITA              NYT                       4  2017-06-28 11:48:50   TABLE        Uppflettitafla fyrir innslátt á innyflafitukóða. LYKILL: fita,tegund. Eingöngu notað ennþá í kvarnainnslætti fyrir síld.                                                                                                                                      
FISKAR   KVARNAFLOKKAR            NYT                       6  2017-06-28 11:50:17   TABLE        Uppflettitafla sem geymir lýsingar og greiningar á kvörnum. LYKILL: flokkur,tegund. Notað við skráningu í töflu KVARNIR (eingöngu fyrir þorsk).                                                                                                               
FISKAR   KVARNIR                  NYT                 5713298  2017-09-30 14:00:53   TABLE        Grunntafla sem inniheldur upplýsingar úr greiningu stakra fiska (oft kvarnaðra eða hreistraðra) og þá helst aldursgreining,lengd,kyn,kynthroski,þyngd fisks.
LYKILL: synis_id,tegund                                                                          
FISKAR   KYN                      NYT                       2  2017-06-28 11:51:35   TABLE        Kyn merktra fiska                                                                                                                                                                                                                                             
FISKAR   KYNTHROSKI               NYT                    2812  2017-06-28 11:51:35   TABLE        Uppflettitafla fyrir lýsingu á kynþroskastigi fiska/dýra. LYKILL: throski,tegund. Notað við innslátt á kynthroska í lengda- og kvarnainnslætti.                                                                                                               
FISKAR   LEIDANGRAR               NYT                    9366  2017-06-28 11:52:38   TABLE        Uppflettitafla sem geymir upplýsingar um hvern leiðangur Hafrannsóknastofnunarinnar. LYKILL:leidangur                                                                                                                                                         
FISKAR   LEIDR_KVARNIR            NYT                 1570478  2017-06-28 11:52:43   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   LEIDR_LENGDIR            NYT                 2329341  2017-06-28 11:52:47   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   LEIDR_NUMER              NYT                  230381  2017-06-28 11:52:48   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   LEIDR_STODVAR            NYT                   65481  2017-06-28 11:52:50   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   LENGDIR                  NYT                14040360  2017-09-30 14:01:39   TABLE        Grunntafla sem inniheldur aðallega lengdardreifingu sýnis fyrir hverja tegund.
LYKILL: synis_id,tegund                                                                                                                                                        
FISKAR   L_HAFNIR                 NYT                      92  2017-06-28 11:53:18   TABLE        Staðsetningar og númer löndunarhafna                                                                                                                                                                                                                          
FISKAR   LINIR                    NYT                   34469  2017-06-28 11:53:23   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   MELTING_BRADAR           NYT                       3  2017-06-28 11:58:06   TABLE        Tengis túnfiski                                                                                                                                                                                                                                               
FISKAR   MELTING_KVARNA           NYT                       3  2017-06-28 11:58:06   TABLE        Tengis túnfiski                                                                                                                                                                                                                                               
FISKAR   NUMER                    NYT                 1333832  2017-09-30 14:01:25   TABLE        Grunntafla sem inniheldur upplýsingar fyrir hverja tegund sem er talin,mæld,kvörnuð,hreistruð o.sv.frv. á sömu stöð; einnig innsláttarupplýsingar og ef við á gömlu lnr og knr úr Prelude gagnagrunnskerfinu 
 LYKILL: synis_id,tegund                        
FISKAR   OSKJUR                   NYT                  321813  2017-06-28 11:59:07   TABLE        Bókhald yfir staðsetningu kvarna                                                                                                                                                                                                                              
FISKAR   SJOR                     NYT                      10  2017-06-28 12:02:19   TABLE        Uppflettitafla umhverfisþátta; lýsing á ástandi sjávar. Lykill sjor.                                                                                                                                                                                          
FISKAR   SKIKAR                   NYT                     267  2017-06-28 12:02:20   TABLE        Rækju rannsókninar                                                                                                                                                                                                                                            
FISKAR   SKY                      NYT                      10  2017-06-28 12:04:34   TABLE        Uppflettitafla umhverfisþátta; lýsing á skýjafari. LYKILL: sky.                                                                                                                                                                                               
FISKAR   SPURN                    NYT                       3  2017-06-28 12:04:52   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   STADA_KVARNIR            NYT                      15  2017-06-28 12:04:54   TABLE        Staða innsláttar kvarna, lesið/ólesi o.s.fr.                                                                                                                                                                                                                  
FISKAR   STADA_LENGDIR            NYT                       5  2017-06-28 12:04:54   TABLE        Staða innsláttar lengda, lesið/ólesi o.s.fr.                                                                                                                                                                                                                  
FISKAR   STADA_STODVA             NYT                       8  2017-06-28 12:04:59   TABLE        Lýsing hvernig til tókst.                                                                                                                                                                                                                                     
FISKAR   STODVAR                  NYT                  378788  2017-09-30 14:01:48   TABLE        Grunntafla sem inniheldur aðalstöðvarupplýsingar sem skráðar eru við sýnatöku allra fisktegunda. Aðeins ein færsla er fyrir hverja stöð. EINKVÆMUR LYKILL: synis_id                                                                                           
FISKAR   SYNAFLOKKAR              NYT                      37  2017-06-28 12:05:52   TABLE        Uppflettitafla yfir synatökuflokka. Tilgangur sýnaflokka er að flokka í sundur mismunandi tegunda rannsókna s.s SMB,SMR og Seiðarannsóknir. Með tilkomu synaflokka á að vera óþarfi að nota veiðarfæri eða leiðangursauðkenni til að vinsa t.d. SMB úr Oracle 
FISKAR   TOGEYKTIR                NYT                      12  2017-06-28 12:06:43   TABLE        Uppflettitafla með skýringum um eyktarkóða þegar sólarhringnum er skipt niður í tólf hluta. LYKILL: eykt.                                                                                                                                                     
FISKAR   TOGSTODVAR               NYT                  293198  2017-09-30 14:01:20   TABLE        Grunntafla sem inniheldur togupplýsingar sem skráðar eru við sýnatöku allra fiskategunda svo sem tognúmer,toghraði,toglengd; Í þessa töflu er eingöngu skráð ef togþættir eru fyrir hendi í frumgögnum.
LYKILL: sýnis_id                                      
FISKAR   TUNA_BRAD                NYT                    3975  2017-06-28 12:13:08   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   TUNA_FERSKIR             NYT                      62  2017-06-28 12:13:09   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   TUNA_HARDIR              NYT                    7857  2017-06-28 12:13:09   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   TUNFISK_FAEDA            NYT                     310  2017-06-28 12:13:09   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   TYPA                     NYT                      17  2017-06-28 12:13:12   TABLE        Síld                                                                                                                                                                                                                                                          
FISKAR   UMHVERFI                 NYT                  219662  2017-09-30 14:01:45   TABLE        Grunntafla sem inniheldur umhverfiupplýsingar sem skráðar eru við sýnatöku allra fiskategunda svo sem vindátt,vindhraði,loftþrýstingur; Í þessa töflu er eingöngu skráð ef umhverfisþættir eru fyrir hendi í frumgögnum
LYKILL: synis_id                      
FISKAR   UTIBU                    NYT                       7  2017-06-28 12:13:45   TABLE        Uppflettitafla yfir útibú Hafrannsóknastofnunar.                                                                                                                                                                                                              
FISKAR   VALKVARNIR               NYT                   20884  2017-06-28 12:13:49   TABLE        Kvarnatafla með völdum fiskum (lengdir ekki settar í fiskar lengdir)                                                                                                                                                                                          
FISKAR   VEDUR                    NYT                      10  2017-06-28 12:13:50   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   VINDATT                  NYT                      18  2017-06-28 12:18:59   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   VINDHRADI                NYT                      13  2017-06-28 12:18:59   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   FRJOSEMI                 NYT                    1209  2017-06-28 11:35:49   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   FRJOSEMI_EGGJATHVERMAL   NYT                       0  2017-06-28 11:35:49   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   STODVAR_LOG              NYT                 1198802  2017-09-22 22:00:34   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   LEIDANGRAR_LOG           NYT                    9413  2017-09-22 22:00:15   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   TOGSTODVAR_LOG           NYT                 1131117  2017-09-22 22:00:23   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   UMHVERFI_LOG             NYT                  444834  2017-09-22 22:00:16   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   NUMER_LOG                NYT                 1816227  2017-09-30 14:01:57   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   LENGDIR_LOG              NYT                28853470  2017-09-30 14:02:53   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   KVARNIR_LOG              NYT                 7192049  2017-09-30 14:01:19   TABLE        NA                                                                                                                                                                                                                                                            
FISKAR   HORPUDISKUR              NYT                      13  2017-11-15 22:00:13   TABLE        Tafla fyrir greiningu tegund á (hörpudisk)myndum                                                                                                                                                                                                              

Description of the columns of a particular table:


```r
mar_fields(con,'fiskar.stodvar') %>% knitr::kable()
```



owner    table_name   column_name       comments                                                                                               
-------  -----------  ----------------  -------------------------------------------------------------------------------------------------------
fiskar   stodvar      synis_id          Lykilnúmer stöðvar og tengir það  saman öll fiskasýni á sömu stöð                                      
fiskar   stodvar      leidangur         Leiðangurs auðkenni t.d 'B9-90' vísar í töflu LEIÐANGRAR.                                              
fiskar   stodvar      dags              Dagsetning sýnatöku/mælidagur ef um sjálfvikasínatöku er um að ræða                                    
fiskar   stodvar      skip              Skipaskráarnúmer skips                                                                                 
fiskar   stodvar      stod              Númer stöðvar                                                                                          
fiskar   stodvar      reitur            Tilkynningarskyldureitur sýnatöku                                                                      
fiskar   stodvar      smareitur         Hólf innan tilkynningarskyldureits                                                                     
fiskar   stodvar      kastad_n_breidd   Staðsetning á norðurbreidd við kast í gráðum,mínútum og hundraðshluta úr mínútu                        
fiskar   stodvar      kastad_v_lengd    Staðsetning á vesturlengd við kast í gráðum,mínútum og hundraðshluta úr mínútu                         
fiskar   stodvar      hift_n_breidd     Staðsetning á norðurbreidd við hífingu í gráðum,mínútum og hundraðshluta úr mínútu                     
fiskar   stodvar      hift_v_lengd      Staðsetning á vesturlengd við hífingu í gráðum,mínútum og 1/100 úr mínútu                              
fiskar   stodvar      dypi_kastad       Botndýpi í metrum við kast                                                                             
fiskar   stodvar      dypi_hift         Botndýpi í metrum við hífingu                                                                          
fiskar   stodvar      veidarfaeri       Veiðarfærakóði vísar í töflu FISKAR.VEIDARFAERI                                                        
fiskar   stodvar      moskvastaerd      Möskvastærð veiðarfæris í millimetrum                                                                  
fiskar   stodvar      grandaralengd     Grandaralengd í föðmum                                                                                 
fiskar   stodvar      heildarafli       Þyngd afla samtals í heilum kílóum                                                                     
fiskar   stodvar      londunarhofn      Kóði löndunarhafnar; vísar í töflu FISKAR.LONDUNARHAFNIR                                               
fiskar   stodvar      skiki             Svæði samkvæmt tilkynningarskyldu rækjubáta: eingöngu skráð í rækjukönnun; vísar í töflu FISKAR.SKIKAR 
fiskar   stodvar      fjardarreitur     Reitur innan skika inn í fjörðum; eingöngu skráð í rækjukönnun; vísar í töflu FISKAR.SKIKAR            
fiskar   stodvar      snt               Stimpill fyrir nýja færslu: dags. skráningar (SYSDATE)                                                 
fiskar   stodvar      snn               Stimpill fyrir nýja færslu: hver skráði (USER)                                                         
fiskar   stodvar      sbt               Stimpill fyrir breytingu á færslu: dags. breytingar (SYSDATE)                                          
fiskar   stodvar      sbn               Stimpill fyrir breytingu á færslu: hver skráði (USER)                                                  
fiskar   stodvar      hnattstada        Kóði fyrir hnattfjórðung (0-n.br/a.le, 1->n.br/v.le, 2->s.br/a.le, 3->s.br/v.le)                       
fiskar   stodvar      landsyni          Er sýni tekið í landi (1) eða út á sjó (0) ?                                                           
fiskar   stodvar      aths              Athugasemdir varðandi stöð og lýsing á togi                                                            
fiskar   stodvar      stada_stodvar     NA                                                                                                     
fiskar   stodvar      net_nr            NA                                                                                                     
fiskar   stodvar      synaflokkur       Sýnaflokkur, vísar í töfluna SYNAFLOKKAR                                                               
fiskar   stodvar      veidisvaedi       NA                                                                                                     
fiskar   stodvar      hitamaelir_id     NA                                                                                                     
fiskar   stodvar      maelingarmenn     NA                                                                                                     
fiskar   stodvar      veidarfaeri_id    NA                                                                                                     
fiskar   stodvar      tog_aths          NA                                                                                                     
fiskar   stodvar      medferd_afla      NA                                                                                                     



### Something else (more advanced)
____

... pending

### Working with stomach data
____

Let's look at stomach samples. Restrict our analysis to fish from the spring survey after 1992.



```r
st <- 
  lesa_stodvar(con) %>% 
  filter(synaflokkur == 30, ar > 1992) %>% 
  select(synis_id,ar)
```
  
and only look at stomachs from cods between 40 and 80 fish


```r
tmp <- 
  faeda_ranfiskar(con) %>% 
  filter(lengd %in% 40:80,ranfiskur == 1) %>% 
  mutate(weight = 0.01*lengd^3) %>% 
  right_join(st) %>% 
  left_join(faeda_thyngdir(con)) %>% 
  mutate(faeduhopur = nvl(faeduhopur,'Empty'),
         thyngd = nvl(thyngd,0))
```

Look at the average percentage of body weight capelin in the stomach is in the spring survey compared to other species

```r
tmp %>% 
  left_join(tmp %>% 
              group_by(flokk_id) %>% 
              summarise(total = sum(thyngd))) %>% 
  select(ar,flokk_id,faeduhopur,thyngd,total,weight) %>% 
  group_by(ar,flokk_id,faeduhopur,weight) %>%  ## why do we have duplicate prey entries?
  summarise(thyngd=sum(thyngd),total=sum(total)) %>% 
  collect(n=Inf) %>% 
  ungroup() %>% 
  spread(faeduhopur,thyngd,fill=0) %>% ## this function should be availabe in the database
  select(ar,flokk_id,weight,capelin=`mall vil`,total) %>% 
  mutate(otherfood = (total - capelin)/weight,
         capelin = capelin/weight) %>%  
  select(ar,capelin,otherfood) %>% 
  gather(Prey,prop,-ar) %>% 
  group_by(ar,Prey) %>% 
  summarise(prop=mean(prop,na.rm=TRUE)) %>% 
  ggplot(aes(ar,prop,fill=Prey)) + geom_bar(stat = 'identity')
```

![](README_files/figure-html/unnamed-chunk-26-1.png)<!-- -->




```r
devtools::session_info()
```

```
##  setting  value                       
##  version  R version 3.4.2 (2017-09-28)
##  system   x86_64, linux-gnu           
##  ui       X11                         
##  language (EN)                        
##  collate  is_IS.UTF-8                 
##  tz       Atlantic/Reykjavik          
##  date     2017-12-13                  
## 
##  package    * version    date      
##  assertthat   0.2.0      2017-04-11
##  backports    1.1.1      2017-09-25
##  base       * 3.4.2      2017-10-30
##  bindr        0.1        2016-11-13
##  bindrcpp   * 0.2        2017-06-17
##  broom        0.4.2      2017-02-13
##  cellranger   1.1.0      2016-07-27
##  cli          1.0.0      2017-11-05
##  colorspace   1.3-2      2016-12-14
##  compiler     3.4.2      2017-10-30
##  crayon       1.3.4      2017-11-15
##  data.table   1.10.5     2017-12-01
##  datasets   * 3.4.2      2017-10-30
##  DBI        * 0.7        2017-06-18
##  dbplyr       1.1.0.9000 2017-11-15
##  devtools     1.13.3     2017-08-02
##  digest       0.6.12     2017-01-27
##  dplyr      * 0.7.4      2017-09-28
##  evaluate     0.10.1     2017-06-24
##  forcats    * 0.2.0      2017-01-23
##  foreign      0.8-69     2017-06-21
##  ggplot2    * 2.2.1.9000 2017-12-01
##  gisland      0.0.07     2017-12-12
##  glue         1.2.0      2017-10-29
##  graphics   * 3.4.2      2017-10-30
##  grDevices  * 3.4.2      2017-10-30
##  grid         3.4.2      2017-10-30
##  gtable       0.2.0      2016-02-26
##  haven        1.1.0      2017-07-09
##  highr        0.6        2016-05-09
##  hms          0.3        2016-11-22
##  htmltools    0.3.6      2017-04-28
##  httr         1.3.1      2017-08-20
##  jsonlite     1.5        2017-06-01
##  knitr        1.17       2017-08-10
##  labeling     0.3        2014-08-23
##  lattice      0.20-35    2017-03-25
##  lazyeval     0.2.1      2017-10-29
##  lubridate    1.7.1      2017-11-03
##  magrittr     1.5        2014-11-22
##  mar        * 0.0.3.9000 2017-12-13
##  memoise      1.1.0      2017-04-21
##  methods    * 3.4.2      2017-10-30
##  mnormt       1.5-5      2016-10-15
##  modelr       0.1.1      2017-07-24
##  munsell      0.4.3      2016-02-13
##  nlme         3.1-131    2017-02-06
##  parallel     3.4.2      2017-10-30
##  pkgconfig    2.0.1      2017-03-21
##  plyr         1.8.4      2016-06-08
##  psych        1.7.8      2017-09-09
##  purrr      * 0.2.4      2017-10-18
##  R6           2.2.2      2017-06-17
##  Rcpp         0.12.14    2017-11-23
##  readr      * 1.1.1      2017-05-16
##  readxl       1.0.0      2017-04-18
##  reshape2     1.4.2      2016-10-22
##  rlang        0.1.4      2017-11-05
##  rmarkdown    1.7.7      2017-11-15
##  ROracle    * 1.3-1      2016-10-26
##  rprojroot    1.2        2017-01-16
##  rstudioapi   0.7        2017-09-07
##  rvest        0.3.2      2016-06-17
##  scales       0.5.0.9000 2017-09-11
##  sp         * 1.2-5      2017-06-29
##  stats      * 3.4.2      2017-10-30
##  stringi      1.1.6      2017-11-17
##  stringr    * 1.2.0      2017-02-18
##  tibble     * 1.3.4      2017-08-22
##  tidyr      * 0.7.2      2017-10-16
##  tidyselect   0.2.3      2017-11-06
##  tidyverse  * 1.2.1      2017-11-14
##  tools        3.4.2      2017-10-30
##  utils      * 3.4.2      2017-10-30
##  withr        2.1.0.9000 2017-12-01
##  xml2         1.1.1      2017-01-24
##  yaml         2.1.14     2016-11-12
##  source                                    
##  cran (@0.2.0)                             
##  CRAN (R 3.4.1)                            
##  local                                     
##  cran (@0.1)                               
##  cran (@0.2)                               
##  CRAN (R 3.4.1)                            
##  CRAN (R 3.3.1)                            
##  cran (@1.0.0)                             
##  CRAN (R 3.4.0)                            
##  local                                     
##  Github (r-lib/crayon@b5221ab)             
##  Github (Rdatatable/data.table@8bf7334)    
##  local                                     
##  CRAN (R 3.4.1)                            
##  Github (tidyverse/dbplyr@a424f67)         
##  CRAN (R 3.4.1)                            
##  CRAN (R 3.3.2)                            
##  cran (@0.7.4)                             
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.4.0)                            
##  Github (hadley/ggplot2@7b5c185)           
##  Github (einarhjorleifsson/gisland@480343a)
##  cran (@1.2.0)                             
##  local                                     
##  local                                     
##  local                                     
##  cran (@0.2.0)                             
##  CRAN (R 3.4.0)                            
##  cran (@0.6)                               
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.4.1)                            
##  CRAN (R 3.4.0)                            
##  cran (@1.17)                              
##  CRAN (R 3.2.0)                            
##  CRAN (R 3.4.0)                            
##  cran (@0.2.1)                             
##  CRAN (R 3.4.2)                            
##  CRAN (R 3.1.2)                            
##  local                                     
##  CRAN (R 3.4.0)                            
##  local                                     
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.4.1)                            
##  cran (@0.4.3)                             
##  CRAN (R 3.4.0)                            
##  local                                     
##  cran (@2.0.1)                             
##  cran (@1.8.4)                             
##  CRAN (R 3.4.1)                            
##  CRAN (R 3.4.1)                            
##  cran (@2.2.2)                             
##  cran (@0.12.14)                           
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.3.2)                            
##  cran (@1.4.2)                             
##  cran (@0.1.4)                             
##  Github (rstudio/rmarkdown@2b418a2)        
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.4.0)                            
##  CRAN (R 3.4.1)                            
##  CRAN (R 3.3.2)                            
##  Github (hadley/scales@d767915)            
##  CRAN (R 3.4.0)                            
##  local                                     
##  cran (@1.1.6)                             
##  cran (@1.2.0)                             
##  CRAN (R 3.4.2)                            
##  cran (@0.7.2)                             
##  cran (@0.2.3)                             
##  CRAN (R 3.4.2)                            
##  local                                     
##  local                                     
##  Github (jimhester/withr@fe81c00)          
##  CRAN (R 3.3.2)                            
##  cran (@2.1.14)
```

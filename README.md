# mar


```r
# devtools::install_github("einarhjorleifsson/mar")
library(mar)
library(dplyr)
system.time(st <- read_stations(year = c(2006:2010)))
```

```
   user  system elapsed 
  1.361   0.069   7.999 
```

```r
dim(st)
```

```
[1] 63777    62
```

```r
require(ggplot2)
ggplot(st) +
  theme_bw() +
  geom_point(aes(lon,lat),alpha=0.2, size=1, col="red") +
  geom_polygon(data=gisland::iceland,aes(long,lat,group=group),fill="grey90") +
  coord_map(ylim=c(62,67.8), xlim=c(-31,-9)) +
  labs(x="",y="",title=paste(nrow(st),"MRI stations 2006-2010"))
```

![](README_files/figure-html/unnamed-chunk-1-1.png) 


## ----message=FALSE------------------------------------------------------------
library(tidyverse)
library(mar)
mar <- connect_mar()

## ----fig.width=7--------------------------------------------------------------
afli_grasl(mar) %>% 
  filter(ar == 2015) %>% 
  collect(n = Inf) %>% 
  ggplot(aes(lon, lat)) + 
  #geom_polygon(data=geo::bisland) + 
  geom_jitter(col = 'red', aes(size = fj_grasl), alpha = 0.1) + 
  coord_quickmap()


geoconvert <- function(data, inverse = FALSE, col.names = c("lat", "lon")){
  if(!('tbl_oracle' %in% class(data))){
    return(geo::geoconvert(data,inverse,col.names))
  }
  if(!inverse){
    tmp <- sprintf('geoconvert1(%s)',col.names)
    dplyr::mutate_(data,.dots = setNames(tmp,col.names)) %>%
      select_(.dots=colnames(data))
  } else {
    tmp <- sprintf('geoconvert2(%s)',col.names)
    dplyr::mutate_(data,.dots = setNames(tmp,col.names)) %>%
      select_(.dots=colnames(data))
  }
}

r2d <- function(data,cell.col='r',col.names=c('lat','lon')){
  if(!('tbl_oracle' %in% class(data))){
    mod <- function(x,y) x%%y
  }
  r <-
    data %>%
    dplyr::select_(.dots=setNames(cell.col,'r')) %>%
    dplyr::distinct() %>%
    dplyr::mutate(lat = floor(r/100)) %>%
    dplyr::mutate(lon = mod((r-lat*100),50)) %>%
    dplyr::mutate(halfb = (r - 100*lat - lon)/100) %>%
    dplyr::mutate(lon = -(lon + 0.5)) %>%
    dplyr::mutate(lat = lat + 60 + halfb + 0.25) %>%
    dplyr::select_(.dots = setNames(c('r','lat','lon'),c(cell.col,col.names)))
  data %>%
    dplyr::left_join(r)
}

sr2d <- function(data,cell.col='sr',col.names=c('lat','lon')){
  if(!('tbl_oracle' %in% class(data))){
    mod <- function(x,y) x%%y
  }

  sr <-
    data %>%
    dplyr::select_(.dots=setNames(cell.col,'sr')) %>%
    dplyr::distinct() %>%
    dplyr::mutate(r = floor(sr/10)) %>%
    dplyr::mutate(s = round(sr - r*10,0) + 1,
                  lat = floor(r/100)) %>%
    dplyr::mutate(lon = mod(r - lat*100,50)) %>%
    dplyr::mutate(halfb = (r-100*lat - lon)/100) %>%
    dplyr::mutate(lon = -(lon+0.5),
                  lat = lat + 60 + halfb + 0.25) %>%
    dplyr::mutate(lat = lat + ifelse(s==1, 0,ifelse(s %in% 2:3, 0.125,-0.125)),
                  lon = lon + ifelse(s==1, 0,ifelse(s %in% c(2,4), -0.25, 0.25))) %>%
    dplyr::select_(.dots = setNames(c('sr','lat','lon'),c(cell.col,col.names)))
  data %>%
    dplyr::left_join(sr,by='sr')
}


fix_pos <- function(data,
                    lat='kastad_n_breidd',
                    lon='kastad_v_lengd',...){
  skika.fix <-
    tbl_mar(mar,'fiskar.skikar') %>%
    group_by(skiki,fj_reitur) %>%
    summarise(sr.fix=max(reitur)*10+max(nvl(smareitur,0)))

  tmp <-
    c(sprintf("nvl2(%s,'unchanged','fixed')",lat),sprintf('nvl(%s,lat)',lat),sprintf('nvl(%s,lon)',lon))

  data %>%
    dplyr::mutate(sr = reitur*10 + nvl(smareitur,0)) %>%
    geoconvert(...) %>%
    dplyr::left_join(skika.fix,by='skiki') %>%
    dplyr::mutate(sr = nvl(sr,sr.fix)) %>%
    sr2d() %>%
    dplyr::mutate_(.dots=setNames(tmp,c('pos_fix',lat,lon))) %>%
    select_(.dots = c(colnames(data),'pos_fix'))
}



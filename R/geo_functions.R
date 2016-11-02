geoconvert <- function(data, inverse = FALSE, col.names = c("lat", "lon")){
  if(!('tbl_oracle' %in% class(data))){
    return(geo::geoconvert(data,inverse,col.names))
  }
  if(!inverse){
    tmp <- sprintf('geoconvert1(%s)',col.names)
    dplyr::mutate_(data,.dots = setNames(tmp,col.names))
  } else {
    tmp <- sprintf('geoconvert2(%s)',col.names)
    dplyr::mutate_(data,.dots = setNames(tmp,col.names))
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



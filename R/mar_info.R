#' mar_tables
#'
#' @description Fallið myndar tengingu við schema all_tables
#'
#' @param mar src_oracle tenging við oracle
#' @param schema character vector specifying schema name, e.g. "fiskar"
#'
#' @return dataframe
#' @export

mar_tables <- function(mar, schema) {

  d <- tbl_mar(mar, "all_tables")
  if(!missing(schema)) {
    d <- d %>% filter(owner %in% toupper(schema))
  }

  d %>% select(owner, table_name, tablespace_name, num_rows, last_analyzed)

}


#' mar_fields
#'
#' @description Fallið ...
#'
#' @param mar src_oracle tenging við oracle
#' @param table character vector specifying table names, e.g. "fiskar.stodvar"
#'
#' @note NB - ætti frekar að laga dplyrOracle:::db_query_fields.OraConnection??
#'
#' @return dataframe

mar_fields <- function(mar, table) {

  fields <- build_sql("SELECT * FROM ", dplyr::sql(table), " WHERE 0=1",
                      con = mar$con)
  qry <- DBI::dbSendQuery(con, fields)
  on.exit(DBI::dbClearResult(qry))
  res <- DBI::dbGetInfo(qry)$fields
  res$name <- tolower(res$name)
  res$type <- tolower(res$type)
  return(res)

}

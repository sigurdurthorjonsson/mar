#' mar_tables
#'
#' @description Fallið myndar tengingu við schema all_tables
#'
#' @param mar src_oracle tenging við oracle
#' @param schema character vector specifying table names, e.g. "fiskar". If missing
#' information from all tables are returned.
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

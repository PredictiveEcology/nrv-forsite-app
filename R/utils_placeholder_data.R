#' Generate a row of random NRV status values
#'
#' @param x not used
#'
#' @return a data.frame with 3 cols and 1 row
#'
#' @noRd
random_status_values <- function(x) {
  totl <- 100L
  cuts <- sort(sample.int(totl, 2))
  vals <- sort(c(cuts[1], cuts[2] - cuts[1], totl - cuts[2]), decreasing = TRUE)
  data.frame(STATUS_WITHIN = vals[1], STATUS_MARGINAL = vals[2], STATUS_OUTSIDE = vals[3])
}

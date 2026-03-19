## NOTE: ensure all reporting polygons have character attributes `ID` and `NAME`

REGIONS <- list(
  ecoprovinces = nrvtools::ecoprovinces |>
    dplyr::mutate(
      ## doublecheck ID properly encoded (floating point issues)
      ID = as.character(round(ECOPROVINCE_ID, digits = 1)),
      NAME = as.character(ECOPROVINCE_NAME_EN)
    ) |>
    dplyr::select(ID, NAME)
)

REGION_NAMES <- lapply(names(REGIONS), function(x) {
  paste0(REGIONS[[x]]$NAME, " [", REGIONS[[x]]$ID, "]")
}) |>
  unlist() |>
  unique() |>
  sort()

usethis::use_data(REGIONS, REGION_NAMES, overwrite = TRUE)

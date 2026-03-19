## code to prepare `CANPROVS` dataset goes here
CANPROVS <- geodata::gadm("CA") |> sf::st_as_sf()

usethis::use_data(CANPROVS, overwrite = TRUE)

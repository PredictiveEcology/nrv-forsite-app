ELEMENTS <- read.csv("data-raw/element-lookup.csv")
rownames(ELEMENTS) <- ELEMENTS$species_code

ELEMENT_NAMES <- split(ELEMENTS$species_code, ELEMENTS$group)
ELEMENT_NAMES <- mapply(
  FUN = function(x, y) setNames(x, y),
  x = ELEMENT_NAMES,
  y = split(paste0(ELEMENTS$common_name, " [", ELEMENTS$group, "]"), ELEMENTS$group)
)

usethis::use_data(ELEMENTS, ELEMENT_NAMES, overwrite = TRUE)

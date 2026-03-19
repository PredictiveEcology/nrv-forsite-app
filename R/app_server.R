#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_map_server("map_ui_1")

  mod_regions_server("regions_ui_1")

  mod_methods_server("methods_ui_1")
}

#' methods UI Function
#'
#' @description A shiny module describing the methods used for simulating NRV.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_methods_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h1("Methods"), ## TODO
    p("Coming soon...")
  )
}

#' methods Server Functions
#'
#' @noRd
mod_methods_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}

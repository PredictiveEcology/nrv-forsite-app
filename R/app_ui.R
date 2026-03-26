#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(bslib::page_navbar(
      id = "nav_bar",
      title = span(
        img(src = "www/favicon.ico", height = 30),
        shiny::a(
          span(strong("FORSITE NRV"), style = "color: #E1E375"), # Predictive Ecology Yellow
          href = "https://predictiveecology.org/",
          style = "text-decoration: none;"
        )
      ),
      bg = "#607086",
      theme = bslib::bs_theme(
        version = 5,
        bootswatch = "zephyr",
        bg = "#FFFFFF",
        fg = "#000000",
        primary = "#C4161C", # Predictive Ecology Red/Orange
        base_font = bslib::font_google("Arvo")
      ),

      # "Map" Page ----
      bslib::nav_panel(
        title = "Map",

        mod_map_ui("map_ui_1")
      ),

      # "Regions" Page ----
      bslib::nav_panel(
        title = "Regions",

        mod_regions_ui("regions_ui_1")
      ),

      # "Methods" Page ----
      bslib::nav_panel(
        title = "Methods",

        mod_methods_ui("methods_ui_1")
      )
    ))
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path("www", app_sys("app/www"))

  tags$head(
    favicon(ext = "png"),
    bundle_resources(path = app_sys("app/www"), app_title = "nrv.forsite.app")
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

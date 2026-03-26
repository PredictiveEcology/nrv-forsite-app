#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
mod_map_ui <- function(id) {
  ns <- NS(id)
  tagList(div(
    class = "outer",

    # Map ----
    leaflet::leafletOutput(outputId = ns("map"), width = "100%", height = "100%"),

    # Panel ----
    absolutePanel(
      id = "controls",
      class = "panel panel-default",
      fixed = TRUE,
      draggable = TRUE,
      top = 80,
      left = "auto",
      right = 20,
      bottom = "auto",
      width = 350,
      height = "auto",

      br(),

      shinyWidgets::pickerInput(
        inputId = ns("map_element"),
        label = "Select element:",
        choices = ELEMENT_NAMES,
        selected = ELEMENT_NAMES$bird[[1]],
        options = list(
          `live-search` = TRUE
          # style = "border-color: #999999;"
          # style = paste0(
          #   "background-color: white; ",
          #   "border-color: #999999; ",
          #   "font-family: 'Helvetica Neue' Helvetica; ",
          #   "font-weight: 200;"
          # )
        )
      ),

      shinyWidgets::pickerInput(
        inputId = ns("map_region"),
        label = "Select region:",
        choices = REGION_NAMES,
        selected = ELEMENT_NAMES[["landscape"]][[2]], ## biomass
        options = list(
          `live-search` = TRUE
          # style = "border-color: #999999;"
          # style = paste0(
          #   "background-color: white; ",
          #   "border-color: #999999; ",
          #   "font-family: 'Helvetica Neue' Helvetica; ",
          #   "font-weight: 200;"
          # )
        )
      ),

      bslib::card(
        bslib::card_header("Forest degradation status"),

        plotOutput(ns("nrv_status_waffle")),

        bslib::value_box(
          title = "Within NRV",
          value = textOutput(ns("nrv_status_within")),
          theme = bslib::value_box_theme(bg = "#006400") # "darkgreen"
        ),

        bslib::value_box(
          title = "Marginally within NRV",
          value = textOutput(ns("nrv_status_marginal")),
          theme = bslib::value_box_theme(bg = "#DAA520") ## "goldenrod"
        ),

        bslib::value_box(
          title = "Outside NRV",
          value = textOutput(ns("nrv_status_outside")),
          theme = bslib::value_box_theme(bg = "#A020F0") ## "purple"
        )
      ),

      br(),

      actionButton(
        inputId = ns("edit_map_settings"),
        label = "Change Preferences",
        icon = icon("gear")
      )
    )
  ))
}

#' map server functions
#'
#' @noRd
mod_map_server <- function(id, elements) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    ## Set Initial Filter Selections ----
    # Create a `reactiveValues` list to hold current selections for each filter
    # in the modal; this will help make user choices redundant when re-launching
    # the modal.
    # Start by setting some defaults that will appear the first time the modal
    # is launched
    current_selections <- reactiveValues(palette = "spectral", opacity = 0.3)

    ## Modal ----
    # Create modal to hold all input widgets / filters
    observeEvent(input$edit_map_settings, {
      modal <- modalDialog(
        title = "Set Map Preferences",

        selectInput(
          inputId = ns("map_palette"),
          label = "Color Palette:",
          choices = c(
            "Spectral" = "spectral",
            "Viridis" = "viridis",
            "Red Yellow Blue" = "rdylbu",
            "BAM" = "bam"
          ),
          selected = current_selections$palette
        ),

        sliderInput(
          inputId = ns("map_opacity"),
          label = "Opacity:",
          min = 0,
          max = 1,
          value = current_selections$opacity
        ),

        footer = actionButton(inputId = ns("close_modal"), label = "Apply"),

        size = "s",
        easyClose = TRUE
      )

      showModal(modal)
    })

    # When the "Apply" button is clicked in the modal, capture the inputs to
    # apply when the modal is re-launched
    observeEvent(input$close_modal, {
      current_selections$palette <- input$map_palette
      current_selections$opacity <- input$map_opacity

      removeModal(session = session)
    })

    # Map ----
    output$map <- leaflet::renderLeaflet({
      base_map() |>
        leaflet::addPolygons(data = REGIONS[[1]], color = ~"darkblue", layerId = ~ID) |>
        leaflet::addMeasure(position = "topleft") |>
        htmlwidgets::onRender(
          "
        function(el, x) {
          this.on('baselayerchange', function(e) {
            e.layer.bringToBack();
          })
        }
      "
        )
    })

    observeEvent(input$map_shape_click, {
      ## Update the select input with the clicked polygon's ID
      updateSelectInput(session, "map_region", selected = input$map_shape_click$id)
    })

    observeEvent(input$map_region, {
      region_id <- stringr::str_extract(input$map_region, "(?<=\\[).*(?=\\])")
      leaflet::leafletProxy("map") |>
        leaflet::clearShapes() |>
        leaflet::addPolygons(
          data = REGIONS[[1]],
          color = ~ ifelse(ID == region_id, "red", "darkblue"),
          layerId = ~ paste0(NAME, " [", ID, "]")
        )
    })

    status_df <- purrr::map_df(
      .x = seq_len(nrow(REGIONS$ecoprovinces)),
      .f = random_status_values
    ) |>
      dplyr::bind_rows()

    ## TODO: populate similar table with real data
    NRV_STATUS <- data.frame(
      TYPE = "ecoprovinces",
      ID = REGIONS$ecoprovinces$ID,
      NAME = REGIONS$ecoprovinces$NAME
    ) |>
      dplyr::bind_cols(status_df)

    nrv_status_df <- reactive({
      req(input$map_region)

      region_id <- stringr::str_extract(input$map_region, "(?<=\\[).*(?=\\])")
      dplyr::filter(NRV_STATUS, ID == region_id)
    })

    output$nrv_status_within <- renderText({
      dplyr::select(nrv_status_df(), STATUS_WITHIN) |> dplyr::pull() |> paste0("%")
    })

    output$nrv_status_marginal <- renderText({
      dplyr::select(nrv_status_df(), STATUS_MARGINAL) |> dplyr::pull() |> paste0("%")
    })

    output$nrv_status_outside <- renderText({
      dplyr::select(nrv_status_df(), STATUS_OUTSIDE) |> dplyr::pull() |> paste0("%")
    })

    output$nrv_status_waffle <- renderPlot(
      {
        req(nrv_status_df())

        print(nrv_status_df())

        nrv_status_df() |>
          tidyr::pivot_longer(
            cols = dplyr::starts_with("STATUS_"),
            names_to = "STATUS",
            names_prefix = "STATUS_",
            names_transform = tolower,
            values_to = "VALUE"
          ) |>
          dplyr::select(STATUS, VALUE) |>
          waffle::waffle(
            parts = _,
            rows = 10,
            size = 2,
            colors = c("darkgreen", "goldenrod", "purple")
          ) +
          ggplot2::theme_void() +
          ggplot2::theme(
            # legend.key.size = ggplot2::unit(1, "cm"),
            legend.position = "none",
            plot.background = ggplot2::element_rect(fill = "transparent", color = NA)
          )
      },
      bg = "transparent"
    )
  })
}

# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

## Fill the DESCRIPTION ----
## Add meta data about your application and set some default {golem} options
##
## /!\ Note: if you want to change the name of your app during development,
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
##
golem::fill_desc(
  pkg_name = "nrv.forsite.app", # The name of the golem package containing the app (typically lowercase, no underscore or periods)
  pkg_title = "Shiny App For Exploring FORSITE NRV Simulation Outputs",
  pkg_description = "Build and deploy FORSITE NRV shiny app.",
  authors = c(
    person(
      given = "Alex M.",
      family = "Chubaty",
      role = c("aut", "cre"),
      email = "achubaty@for-cast.ca",
    ),
    person(given = "Peter", family = "Solymos", role = c("aut"), email = "peter@analythium.io"),
    person(
      given = "Michael",
      family = "Thomas",
      role = c("ctb"),
      email = "mthomas@ketchbrookanalytics.com"
    ),
    person(
      given = "Brad",
      family = "Lindblad",
      role = c("ctb"),
      email = "blindblad@ketchbrookanalytics.com"
    )
  ),
  repo_url = "https://github.com/FOR-CAST/nrv-forsite-app",
  pkg_version = "0.0.0.9000",
  set_options = TRUE # Set the global golem options
)

## Install the required dev dependencies ----
golem::install_dev_deps()

## Create Common Files ----
## See ?usethis for more information
usethis::use_gpl_license(2)
golem::use_readme_rmd(open = FALSE)
usethis::use_lifecycle_badge("Experimental")
devtools::build_readme()

usethis::use_code_of_conduct(contact = "Alex Chubaty")
usethis::use_news_md(open = FALSE)

## Init Testing Infrastructure ----
## Create a template for tests
golem::use_recommended_tests()

## Favicon ----
# If you want to change the favicon (default is golem's one)
golem::use_favicon(
  "https://raw.githubusercontent.com/PredictiveEcology/SpaDES/main/man/figures/SpaDES.png"
)
# golem::remove_favicon()

## Add helper functions ----
golem::use_utils_ui(with_test = TRUE)
golem::use_utils_server(with_test = TRUE)

## Use git ----
usethis::use_git()
## Sets the remote associated with 'name' to 'url'
usethis::use_git_remote(name = "origin", url = "https://github.com/<OWNER>/<REPO>.git")

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile("dev/02_dev.R")

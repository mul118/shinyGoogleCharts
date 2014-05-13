.onLoad <- function(libname, pkgname) {
  require(shiny)
  require(RJSONIO)
  addResourcePath("shinyGoogleCharts", system.file("www", package = "shinyGoogleCharts"))
}

.onAttach <- function(libname, pkgname) {
  require(shiny)    
} 
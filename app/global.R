#Check packages 
packages.used <- as.list(
  c("shiny", 
    "shinyWidgets",
    "plotly", 
    "ggmap","shinyjs","shinydashboard"))

check.pkg<-function(x){
  if(!require(x,character.only=T))
    install.packages(x,character.only=T,dependence=T)}

#check if packages needed are installed
lapply(packages.used, check.pkg)

#load packages
library(shiny)
#library(leaflet)
#library(data.table)
library(plotly)
#library(shinythemes)
library(shinyWidgets)
#library(googleVis)
library(ggmap)
library(shinyjs)
#library(dashboardthemes)
library(shinydashboard)
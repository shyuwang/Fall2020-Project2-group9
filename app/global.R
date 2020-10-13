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
library(leaflet)
library(data.table)
library(plotly)
library(shinythemes)
library(shinyWidgets)
library(googleVis)
library(ggmap)
library(shinyjs)
library(dashboardthemes)
library(shinydashboard)
library(gganimate)
library(rgdal)


# Pre Process COVID Data
url<- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/boro/boroughs-case-hosp-death.csv")
cases <- read.csv(text=url)
cases$DATE_OF_INTEREST <- as.Date(cases$DATE_OF_INTEREST, '%m/%d/%Y')


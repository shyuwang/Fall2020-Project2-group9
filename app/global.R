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
zcta_to_modzctaURL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/Geography-resources/ZCTA-to-MODZCTA.csv")
zcta_to_modzcta <- read.csv(text=zcta_to_modzctaURL)
head(zcta_to_modzcta)
# Get Density of Restaurants in a zipCode
load("./output/res_dat.RData")
head(res_dat)
class(res_dat$postcode)
class(zcta_to_modzcta)



dense_rest <- res_dat%>%
  select(postcode)%>%
  mutate(
    modzcta = zcta_to_modzcta$MODZCTA[match(res_dat$postcode,zcta_to_modzcta$ZCTA)]
  )
# Some zip codes were not included in the NYC Covid because they represent such small
# areas. Combining the small zip codes with their MODZCTA
dense_rest$modzcta[dense_rest$postcode== 11249]<-11211
dense_rest$modzcta[dense_rest$postcode== 10104]<-10018
dense_rest$modzcta[dense_rest$postcode== 10281]<-10005
dense_rest$modzcta[dense_rest$postcode== 10158]<-10017

amount_tbl <-data.frame(table(dense_rest$modzcta))
head(amount_tbl)
colnames(amount_tbl) = c("modzcta", "amount")
head(amount_tbl)
save(amount_tbl, file="./output/res_amounts.RData")

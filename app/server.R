
#source('global.R')
library(RCurl)
library(tidygeocoder)
library(ggmap)
library(ggplot2)
library(RCurl)
library(viridis)
library(leaflet)
library(sp)
library(geojsonR)
library(leaflet)

shinyServer(function(input,output, session){
  
  #page<-read_html("https://github.com/nychealth/coronavirus-data/blob/master/summary.csv")
  #num<-page%>%
  #  html_nodes("td")%>%html_text()
  url2<- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/recent/recent-4-week-by-modzcta.csv")
  recent_4_week <- read.csv(text=url2)
  url3 <-getURL('https://raw.githubusercontent.com/nychealth/coronavirus-data/master/boro/boroughs-by-age.csv')
  boros_by_age <- read.csv(text=url3)
  zipcodes <- geojsonio::geojson_read("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/Geography-resources/MODZCTA_2010_WGS1984.geo.json", what = 'sp')
  
  load(file="./output/res_amounts.RData")
  
  output$time<-renderText({"time"}) #paste("Date Updated:",num[16])
  
  output$total<- renderValueBox({
    valueBox(#num[4],
      1,
      subtitle = "Total Cases",
      icon = icon("stethoscope"),
      color = "maroon")
  })
  
  output$hosp<- renderValueBox({
    
    valueBox(#num[7],
      2,subtitle = "Total Hospitalized",
      icon = icon("plus"),
      color = "yellow")
  })
  
  output$death<- renderValueBox({
    valueBox(#num[10],
      3,subtitle = "Total Deaths",
      icon = icon("heart-broken"),
      color = "navy")
  })
  
  # Natalie - Percent Change in neighborhood  
  output$case_pct_chg <- renderLeaflet({
    # Color palette
    pal <- colorNumeric(
      palette = "YlOrRd",
      domain = recent_4_week$PCT_CHANGE_2WEEK
    )
    # Make labels for zipcodes 
    labels <- paste0(
      "Zip Code: ", 
      recent_4_week$NEIGHBORHOOD_NAME, "<br/>",
      "Percent Change in Two Weeks: ",
      recent_4_week$PCT_CHANGE_2WEEK, "%"
    )%>%
      lapply(htmltools::HTML)
    
    map <-zipcodes%>%
      leaflet()%>%
      setView(lng=-74.0060, lat=40.7128, zoom = 10)%>%
      addTiles()%>%
      addProviderTiles(providers$CartoDB.Positron)%>%
      addPolygons(
        fillColor = ~pal(recent_4_week$PCT_CHANGE_2WEEK),
        weight =2,
        opacity = 1, 
        color = 'white',
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label= labels)%>%
      addLegend(pal=pal,
                values = ~recent_4_week$PCT_CHANGE_2WEEK,
                opacity =0.7, 
                title=htmltools::HTML("Percent Change<br>
                                      in Two Weeks<br>
                                      by ZCTA"),
                position ='topleft')
      

  })
  
  # Natalie - Amount of Restaurants in an Area 
  output$res_amount <- renderLeaflet({
    # Color palette
    pal <- colorNumeric(
      palette = "YlGnBu",
      domain = amount_tbl$amount
    )
    # Make labels for zipcodes 
    labels <- paste0(
      "Zip Code: ", 
      recent_4_week$NEIGHBORHOOD_NAME, "<br/>",
      "Amount of Restaurants in this Neighborhood: ",
      amount_tbl$amount 
      )%>%
      lapply(htmltools::HTML)
    
    map <-zipcodes%>%
      leaflet()%>%
      setView(lng=-74.0060, lat=40.7128, zoom = 10)%>%
      addTiles()%>%
      addProviderTiles(providers$CartoDB.Positron)%>%
      addPolygons(
        fillColor = ~pal(amount_tbl$amount),
        weight =2,
        opacity = 1, 
        color = 'white',
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label= labels)%>%
      addLegend(pal=pal,
                values = ~amount_tbl$amount,
                opacity =0.7, 
                title=htmltools::HTML("Amount of Reopened<br>
                                      Rest. in Neighborhood"),
                position ='topleft')
  })

  # Natalie - age distribution of covid bx 
  output$case_age_Bx <- renderLeaflet({
    # Color palette
    pal <- colorNumeric(
      palette = "YlGnBu",
      domain = boros_by_age$BX_CASE_COUNT
    )
    # Make labels for zipcodes 
    labels <- paste0(
      "Zip Code: ", 
      recent_4_week$NEIGHBORHOOD_NAME, "<br/>",
      "Case Rate of Age Range in Neighborhood: ",
      boros_by_age$BX_CASE_COUNT ,"<br/>",
      "Age Range ",
      boros_by_age$group
    )%>%
      lapply(htmltools::HTML)
    
    map <-zipcodes%>%
      leaflet()%>%
      setView(lng=-73.8648, lat=40.8448, zoom = 11)%>%
      addTiles()%>%
      addProviderTiles(providers$CartoDB.Positron)%>%
      addPolygons(
        fillColor = ~pal(boros_by_age$BX_CASE_COUNT),
        weight =2,
        opacity = 1, 
        color = 'white',
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label= labels)%>%
      addLegend(pal=pal,
                values = ~boros_by_age$BX_CASE_COUNT,
                opacity =0.7, 
                title=htmltools::HTML("Case Rate of Age<br>
                                      Group in Neighborhood"),
                position ='topleft')
  })
  
  # Natalie - Age distribution of covid cases manh
  
  
})


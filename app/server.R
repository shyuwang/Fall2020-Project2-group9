


shinyServer(function(input,output, session){
  
  #page<-read_html("https://github.com/nychealth/coronavirus-data/blob/master/summary.csv")
  #num<-page%>%
  #  html_nodes("td")%>%html_text()
  
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
  
  
  
  
})



#UI
require(leaflet)

#start ui
ui <- dashboardPage(skin="blue",
                    dashboardHeader(title = "NYC COVID-19 & DINING",titleWidth=266),
                    
                    dashboardSidebar(
                      width=266,
                      sidebarMenu(
                        menuItem("Home", tabName = "Home", icon = icon("home")),
                        menuItem("Map", tabName = "Map", icon = icon("map-marker-alt")),
                        menuItem("Results", tabName = "Results", icon = icon("chart-bar"),
                                 startExpanded = TRUE,
                                 menuSubItem("Open Restaurant Report",tabName = "Report"),
                                 menuSubItem("Plot Analysis 1",tabName = "Analysis1"),
                                 menuSubItem("Plot Analysis 2",tabName = "Analysis2")),
                        menuItem("Suggestions", tabName = "Suggestions", icon = icon("heart")),
                        menuItem("Resource", tabName = "Resource", icon = icon("info-circle")),
                        menuItem("Contact", tabName = "Contact", icon = icon("address-card"))
                      )),
                    
                    
                    
                    
                    dashboardBody(
                      
                      #shinyDashboardThemes(
                      #  theme = "onenote"),
                      
                      
                      tabItems(
                        
                        #Home
                        tabItem(tabName = "Home",
                                fluidPage(
                                  
                                  fluidRow(
                                    width = 30, 
                                    h2("Eating Out In NYC Under COVID-19",align = "center"),
                                    h4("FALL 2020 ADS Project 2 by Group 9",align = "center"),
                                    h4("Yiqi Lei, Siran Qiu, Shuyuan Wang, Natalie Williams",align = "center"),
                                    p(""),
                                    h5("project description..."),
                                    tags$div(tags$ul(
                                      tags$li("Interest 1: ..."),
                                      tags$li("Interest 2: ... ")
                                    )),
                                    style = "background-image: url('../bg1.jpg');
                                    background-repeat:no-repeat;background-size:cover;
                                    background-position:center"
                                  ),
                                  
                                  
                                  
                                  fluidRow(
                                    width = 12,
                                    h2("Quick NYC COVID Updates",align = "center"),
                                    textOutput("time"),
                                    valueBoxOutput("total"),
                                    valueBoxOutput("hosp"),
                                    valueBoxOutput("death")
                                  ),
                                  
                                  
                                  fluidRow(
                                    width = 12,
                                    h2("User Mannual",align="center"),
                                    p("On September 30, NYC opened Indoor Dining; On July 20, NYC opened Outdoor and Take-Out and Delivery Food 
                                      Services; On June 8, NYC started Take-Out and Delivery Food Services Only."),
                                    p(""),
                                    p("At this difficult time for all of us, we want to build this website/app?????? to help people in NYC 
                                      who want to eat out and in the 'safest' neighborhood."),
                                    p(""),
                                    p("Under Map, youcan....."),
                                    p("The analyses part contains our detailed analysis of...."),
                                    p("For suggestions, we have some suggestions based on our analyses and the CDC guide for you to
                                      eat out and stay safe."),
                                    p("You can find the data we use under Resource and our contact information under Contact."),
                                    br(),br(),br(),
                                    style = "background-image: url('../bg2.jpg');
                                    background-repeat:no-repeat;background-size:cover;
                                    background-position:center"
                                    )
                                  
                                    )),
                        
                        
                        
                        #MAP Shuyuan's MAP
                        tabItem(tabName = "Map"
                        ),
                        
                        
                        
                        
                        
                        
                        #Results
                        tabItem(tabName = "Report"
                                
                                #Shuyuan's Report
                                
                                
                                
                                
                                ),   
                        
                        
                        #Analysis1
                        tabItem(tabName = "Analysis1",
                                fluidPage(
                                  
                                  ####plot
                                  
                                  fluidRow(
                                    column(12,
                                           h4("In this plot, we analyzed...and found that..."),
                                           tags$div(tags$ul(
                                             tags$li(h4("...")),
                                             tags$li(h4("..."))
                                                  ))
                                           )),
                                  
                                  
                                  #####or plot here
                                  leafletOutput("case_pct_chg")
                                  
                                  )),
                        
                        #Analysis2
                        tabItem(tabName = "Analysis2",
                                fluidPage(
                                  
                                  ####plot
                                  
                                  fluidRow(
                                    column(12,
                                           h4("In this plot, we analyzed...and found that..."),
                                           tags$div(tags$ul(
                                             tags$li(h4("...")),
                                             tags$li(h4("..."))
                                           ))
                                    ))
                                  
                                  
                                  #####or plot here
                                  
                                  
                                  
                                )),
                        
                       
                        
                        
                        
                        #Suggestions
                        tabItem(tabName = "Suggestions",
                                fluidPage(
                                  column(12,
                                         h4("There are some limitations of this project"),
                                         p(""),
                                         h4("We  will give some suggestions based on our analyses. Beside, more health suggestions could be found on CDC website. URL")
                                  ))
                        ),
                        
                        
                        #Resource
                        tabItem(tabName = "Resource",
                                fluidPage(
                                  column(12,
                                         h1(strong("Data We Use"),align = "center"),
                                         br(),
                                         h4(a("NYC Coronavirus Disease 2019 Data",href="https://github.com/nychealth/coronavirus-data"),align="center"),
                                         h4(a("JHU CSSE Covid-19 Data",href="https://github.com/CSSEGISandData/COVID-19"),align="center"),
                                         h4(a("Open Restaurant Data",href="https://data.cityofnewyork.us/Transportation/Open-Restaurant-Applications/pitm-atqc"),align="center"),
                                         br(),
                                         h4(a("Github Link for This Project",href="https://github.com/TZstatsADS/Fall2020-Project2-group9"),align="center"))
                                )),
                        
                        
                        #Contact
                        tabItem(tabName = "Contact",
                                
                                fluidPage(mainPanel(
                                  width=12,
                                  img(src="../contact.png", width = "100%", height = "100%"),
                                  h2(strong("FA20 ADS PROJECT 2 GROUP 9 MEMBERS"),align="center"),
                                  h1(""),
                                  h4("Lei, Yiqi  yl4353@columbia.edu",align="center"),
                                  h1(""),
                                  h4("Qiu, Siran  sq2220@columbia.edu",align="center"),
                                  h1(""),
                                  h4("Wang, Shuyuan  sw3449@columbia.edu",align="center"),
                                  h1(""),
                                  h4("Williams, Natalie  naw2127@columbia.edu",align="center"),
                                  h1(""),
                                  h4(a("Our Github",href="https://github.com/TZstatsADS/Fall2020-Project2-group9"),align="center"),
                                  br(),br()
                                ))
                        )
                        
                                  )))


#UI

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
                                    h5(""),
                                    tags$div(tags$ul(
                                      tags$li("When America’s first COVID -19 case was confirmed on March 1st in New York City, millions of New Yorkers' lives changed. 
                                      Restaurants were ordered to close their doors in March and slowly, restaurants opened over the course of summer 2020. 
                                      On June 8th, NYC entered Phase 1 of the Reopening Plan and restaurants were able to sell food for takeout or delivery only. 
                                      On June 22nd, NYC entered Phase 2 and people can dine outdoors. Indoor dining became allowed on September 30th. "),
                                      tags$li("As New York slowly reopens, politicians and public health experts continue to track the rate of COVID-19 spread. 
                                              We have designed this interactive webpage so New Yorkers can have more information about the areas where they are dining. 
                                              Information is updated daily as data is published by NYC Open Health, and restaurant data originated from NYC Open Restaurants 
                                              publically available permit applications. "),
                                      tags$li("At this difficult time for all of us, we want to build this app to help people in NYC 
                                      who want to eat out and in the 'safest' neighborhood.")
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
                                    h2("User Manual",align="center"),
                                    p("Map: This part helps users to view all open restaurants in certain areas. 
                                    If users where they want to dine out, they could see the number, name and address of open restaurants on the map. 
                                    At the same time, users can search the corresponding ZIP code in the table to the left, 
                                    helping them understand the recent 4-week case rate and positive test rate there."),
                                    p("Results: This part includes basic facts about NYC open restaurants, and several graphs about case rate and open restaurants by borough,
                                      helping users better visualize the relationship between COVID cases and restaurants."),
                                    p("Suggestions: This part contains suggestions based on our analyses, and dining guiding principles from CDC."),
                                    p("You can find the data we use under Resource and our contact information under Contact."),
                                    br(),br(),br(),
                                    style = "background-image: url('../bg2.jpg');
                                    background-repeat:no-repeat;background-size:cover;
                                    background-position:center"
                                    )
                                  
                                    )),
                        
                        
                        
                        #MAP Shuyuan's MAP
                        tabItem(tabName = "Map",
                                fluidPage(
                                  fluidRow(column(6, box(
                                    HTML("Positivity rate is an important indicator. A low COVID positive test rate suggests enough widespread, 
                                    aggressive testing to detect most new cases. WHO recommends a positive test rate of less than 10%. 
                                    The countries most successful in containing COVID have rates of 3% or less. <br/> <br/>
                                    Search the ZIP code of the area you’re interested in dining."), width='200px')),
                                    
                                    column(6, selectizeInput(
                                      'boro',
                                      'Choose the Borough',
                                      choices = c(
                                        'Choose Borough' = '',
                                        'Bronx',
                                        'Brooklyn',
                                        'Manhattan',
                                        'Queens',
                                        'Staten Island'), multiple = T))
                                  ),
                                  
                                  fluidRow(column(6, titlePanel('Recent Situation by ZIP'),
                                                  getDependency('sparkline'),
                                                  dataTableOutput('recentTable', height = "600px")),
                                           column(6, titlePanel('NYC Open Restaurants Map'),
                                                  leafletOutput('resMap', height = "600px"))        
                                           
                                  )
                                )),
                        
                        
                        
                        
                        
                        
                        #Results
                        tabItem(tabName = "Report",
                                fluidPage(
                                  fluidRow(titlePanel("Interactive Dashboard"),
                                           
                                      h4("Facts about NYC open restaurants. Select borough(s) to view the statistics 
                                        regarding the number of open restaurants, their seating type and alcohol service."),
                                      br()
                                       
                                    ),
                                  fluidRow(
                                    valueBoxOutput('resNum'),
                                    valueBoxOutput('resAlco')
                                  ),
                                
                                  fluidRow(
                                    selectizeInput('boro1','   Choose the Borough',
                                                   choices = c('Choose Borough' = '','Bronx','Brooklyn',
                                                              'Manhattan','Queens','Staten Island'), multiple = T, width="30%"),
                                              
                                    highchartOutput('seating_pie',width = "100%")),
            
                                           
                                 
                                  fluidRow(
                                   
                                           tabsetPanel(
                                             type="tabs",
                                             tabPanel("By Borough", highchartOutput("resCountBoro")),
                                             tabPanel("By Alcohol Service",highchartOutput("resByAlco")),
                                             tabPanel("By Seating Type", highchartOutput("resBySeat")),
                                             tabPanel("Application Time Series", highchartOutput("resTS"))
                                             )
                                           
                                    )
                                  )
                                ),
                        
                        
                        #Analysis1
                        tabItem(tabName = "Analysis1",
                                fluidPage(
                                  
                                  ####plot
                                  
                                  fluidRow(
                                    column(12,
                                           h4("In this plot, we analyze cumulative case rate as well as 
                                              the percentage of reopened restaurants by the",
                                              span(strong("beginning of outdoor dining (June 22)")), 
                                              "by borough."),
                                           tags$div(tags$ul(
                                             tags$li(h4("By June 22, Bronx has the highest and Manhattan has the lowest case rate.")),
                                             tags$li(h4("The higher the case rate, the lower percentage the restaurants reopened."))
                                                  ))
                                           , br(), br())),
                                  
                                  
                                  #####or plot here
                                  fluidRow(plotlyOutput("caseResBoroBar")),
                                  
                                  # Section with Visualizations about specific boros 
                                  fluidRow(column(12, h4(
                                    "Interestingly, Manhattan has the highest proportion of reopened restaurants but the lowest case rate.
                                         Below, users can explore pivotal differences between the Bronx and Manhattan, such as case rate per age group")),
                                    
                                    column(6, selectizeInput(
                                      'age_group',
                                      'Choose an age group',
                                      choices = c(
                                        'Choose an age group' = '',
                                        '0-17',
                                        '18-44',
                                        '45-64',
                                        '65-74',
                                        '75+'), multiple = F))
                                  ),
                                  
                                  fluidRow(column(6, titlePanel('Case Rate Per Age Group: Manhattan'),
                                                  leafletOutput('case_age_Mn', height = "400px")),
                                           column(6, titlePanel('Case Rate Per Age Group: The Bronx'),
                                                  leafletOutput('case_age_Bx', height = "400px"))        
                                           
                                  ),
                                  
                                  fluidRow(column(12, h4(
                                    "Across all adult age groups, the Bronx has a visibly higher case rate. 
                                    This difference is widest across working aged people. Among 18-44 year olds, 
                                    Manhattan’s case rate is 1710 and the Bronx’s is  3721. For older working 
                                    aged people, 45-64 year olds, the difference is larger with a case rate of
                                    2590 in Manhattan and 5729 in The Bronx. "))
                                    ),
                                    
                                  
                                  fluidRow(column(6, titlePanel('Case Count Past 4 Weeks: Manhattan'),
                                                  leafletOutput('case_4week_Mn', height = "400px")),
                                           column(6, titlePanel('Case Count Past 4 Weeks: The Bronx'),
                                                  leafletOutput('case_4week_Bx', height = "400px"))        
                                           
                                  ),
                                  
                                  fluidRow(column(12, titlePanel('Case Rate by Poverty Group'),
                                                  plotlyOutput('case_by_pov'))        
                                           
                                  ),
                                  fluidRow(column(12, h4(
                                    "Higher case rates are enough to discourage people from dining out, but we also
                                    know that COVID-19 has had a tremendous impact on people’s financial wellbeing. 
                                    But from the plot above, we can see that case and hospitalization rates are also 
                                    correlated with poverty. The graph above shows that how impoverished one is, the
                                    likelier they are to contract COVID and/or be hospitalized. Seeing that Manhattan 
                                    is richer than the Bronx,  Manhattanites on whole are less likely to contract the
                                    virus and be hospitalized from the virus. This may have an affect on restaurant
                                    patronage, and in turn restaurants are less likely to reopen. Restaurant staffs
                                    in the Bronx may have been hit harder by COVID, or may have greater economic
                                    problems that are limiting their reopening."))
                                    ),
                                  
                                  fluidRow(column(6, titlePanel('Amount of Restaurants in: Manhattan'),
                                                  leafletOutput('res_amt_Mn', height = "400px")),
                                           column(6, titlePanel('Amount of Restaurants in: The Bronx'),
                                                  leafletOutput('res_amt_Bx', height = "400px"))        
                                           
                                  ),
                                  fluidRow(column(12, h4(
                                    "As we can see above, the amount of restaurants in Manhattan in downtown neighborhoods, 
                                    greatly dwarfs the amount of restaurants in upper Manhattan which borders the Bronx. 
                                    The Bronx, on the other hand, does not have nearly as many restaurants as downtown 
                                    Manhattan. This could arise from any of the nuanced differences between Manhattan and
                                    the Bronx, some of which can be seen on the graphs on this page. "))
                                  ),
                                  
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
                                    )),
                                  
                                  
                                  #####or plot here
                                  fluidRow(plotlyOutput("boroPhase"), br(), br()),
                                  
                                  fluidRow(tabsetPanel(type='tabs',
                                                       tabPanel("Open Restaurant", imageOutput("resAnimation")),
                                                       tabPanel("New Case", imageOutput("caseAnimation"))
                                                       )
                                           )
                                  
                                  
                                )),
                        
                       
                        #Suggestions
                        tabItem(tabName = "Suggestions",
                                fluidPage(
                                  column(12,
                                         h4("There are some limitations of this project"),
                                         p(""),
                                         h4("We  will give some suggestions based on our analyses. Beside, more health suggestions could be found on CDC website. URL"),
                                         tags$div(tags$ul(
                                           tags$li("When you want to dine out, please take the neighborhood’s recent new case rate and positivity rate into consideration."),
                                           tags$li("Avoid dining at restaurants where seating capacity is not reduced and tables are not spaced at least 6 feet apart."),
                                           tags$li("Do not dine out, separate yourself from other people and monitor your symptoms  if you are feeling sick."),
                                           tags$li("Before eating food, it is important to always wash your hands with hand sanitizer that contains at least 60% alcohol.")
                                         ))
                                  ))
                        ),
                        
                        
                        #Resource
                        tabItem(tabName = "Resource",
                                fluidPage(
                                  column(12,
                                         h1(strong("Data We Use"),align = "center"),
                                         br(),
                                         h4(a("NYC Coronavirus Disease 2019 Data", href="https://github.com/nychealth/coronavirus-data"), align="center"),
                                         h4(a("JHU CSSE Covid-19 Data",href="https://github.com/CSSEGISandData/COVID-19"), align="center"),
                                         h4(a("Open Restaurant Data",href="https://data.cityofnewyork.us/Transportation/Open-Restaurant-Applications/pitm-atqc"), align="center"),
                                         br(),
                                         h4(a("Github Link for This Project",href="https://github.com/TZstatsADS/Fall2020-Project2-group9"), align="center"))
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

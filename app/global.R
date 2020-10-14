#Check packages 
packages.used <- as.list(
  c("shiny", "shinyWidgets","plotly", "htmltools","highcharter","DT","RCurl","htmlwidgets",
    "ggmap","shinyjs","shinydashboard","dplyr","tibble","leaflet","sparkline","tidyverse","gganimate"))

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
#library(shinythemes)
library(shinyWidgets)
#library(googleVis)
library(ggmap)
library(shinyjs)
#library(dashboardthemes)
library(shinydashboard)
library(sparkline)
library(dplyr)
library(htmltools)
library(RCurl)
library(tidyverse)
library(htmlwidgets)
library(gganimate)

#-----------------------------For main page Quick Update -----------------------
update_URL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/summary.csv")
quick_update <- read.csv(text = update_URL)
#quick_update$NUMBER_OF_NYC_RESIDENTS <- as.character(quick_update$NUMBER_OF_NYC_RESIDENTS)

#---------------------------- For Map part --------------------------------------
#--------------data for the TABLE on left side----------------
# get the daily NYC recent-4-week-by-modzcta.csv data from API
# recent case Table
recent_URL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/recent/recent-4-week-by-modzcta.csv")
recent_cases <- read.csv(text = recent_URL)

recent_use_dat <- recent_cases %>%
  select("MODIFIED_ZCTA","NEIGHBORHOOD_NAME","COVID_CASE_RATE_WEEK4",
         "COVID_CASE_RATE_WEEK3","COVID_CASE_RATE_WEEK2","COVID_CASE_RATE_WEEK1",
         "PERCENT_POSITIVE_4WEEK" )

# transform data from wide to long format
long_use_dat <- recent_use_dat %>%
  select(MODIFIED_ZCTA, COVID_CASE_RATE_WEEK4, COVID_CASE_RATE_WEEK3, 
         COVID_CASE_RATE_WEEK2, COVID_CASE_RATE_WEEK1) %>%
  gather(week,case_rate,COVID_CASE_RATE_WEEK4:COVID_CASE_RATE_WEEK1) %>%
  data.table()

# use sparkline to generate inline line chart inside the table
sparkline_html <- long_use_dat[, .(linechart = spk_chr(case_rate, type = 'line')), by = 'MODIFIED_ZCTA']
recent_use_dat <- recent_use_dat %>%
  select(MODIFIED_ZCTA, NEIGHBORHOOD_NAME, PERCENT_POSITIVE_4WEEK) %>%
  merge(sparkline_html, by = 'MODIFIED_ZCTA') %>%
  rename(Zip=MODIFIED_ZCTA, Neighborhood=NEIGHBORHOOD_NAME, 
         "Testing postivity rate (recent 4 weeks)"=PERCENT_POSITIVE_4WEEK, 
         "Weekly case rate trend (per 100,000)"=linechart)


#-------------data for the MAP --------------------------
# data for restaurant Map
load(file="output/res_dat.RData")

res_map <- res_dat %>%
  filter(!is.na(latitude) | !is.na(longitude)) %>%
  select(name, latitude, longitude, seating, 
         address, alcohol, postcode, borough)
res_map <- res_map[-which(res_map['postcode']=='11249' & res_map['borough']=='Manhattan'),]


#---------------------------data for Report part -------------------------------
# distinct restaurant data
res_dat_distinct <- res_dat %>%
  mutate(dtime = as.POSIXct(strptime(time_submit,'%m/%d/%Y %H:%M:%S %p'))) %>%
  mutate(name_lower = tolower(name)) %>%
  group_by(name_lower, latitude, longitude) %>%
  mutate(rank = with_order(order_by = dtime,
                           fun  = row_number, 
                           x  = desc(dtime))) %>%
  arrange(name_lower, rank) %>%
  filter(rank==1)


# ---------------- number of cases by boro & # of restaurants by boro --------------
boro_ts_URL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/boro/boroughs-case-hosp-death.csv")
boro_ts_cases <- read.csv(text = boro_ts_URL)

# number of cases by the beginning of outdoor dining, by borough
boro_cases1 <- boro_ts_cases %>%
  mutate(date = as.Date(DATE_OF_INTEREST, '%m/%d/%Y')) %>%
  filter(date<'2020-06-22') %>%
  mutate(mn_case = colSums(select(.,MN_CASE_COUNT)),
         qn_case = colSums(select(.,QN_CASE_COUNT)),
         bk_case = colSums(select(.,BK_CASE_COUNT)),
         bx_case = colSums(select(.,BX_CASE_COUNT)),
         si_case = colSums(select(.,SI_CASE_COUNT))) %>%
  select(mn_case,qn_case,bk_case,bx_case,si_case) %>%
  distinct() %>%
  gather(borough_case,case_num,mn_case,qn_case,bk_case,bx_case,si_case) %>%
  mutate(borough=case_when(
    borough_case=='mn_case'~'Manhattan',
    borough_case=='qn_case'~'Queens',
    borough_case=='bk_case'~'Brooklyn',
    borough_case=='bx_case'~'Bronx',
    borough_case=='si_case'~'Staten Island'
  )) %>%
  select(borough, case_num)

# number of restaurants by borough
# data obtained by https://a816-health.nyc.gov/ABCEatsRestaurants/#/Search
res_count <- data.frame(borough=c('Bronx','Brooklyn','Manhattan','Queens','Staten Island'),
                        total=c(2507, 7178, 11248, 6418, 1032))

# number of restaurants applied to reopen by the beginning of outdoor dining, by borough
res_boro_ts <- res_dat %>%
  mutate(date = as.Date(time_submit, '%m/%d/%Y')) %>%
  filter(date<='2020-06-22') %>%
  count(borough)

# proportion of restaurants reopened by the begining of outdoor dining, by borough
res_boro_prop <- res_boro_ts %>%
  full_join(res_count,by='borough') %>%
  mutate(prop=round(n/total,2)) %>%
  select(borough, prop)
res_boro_prop$borough <- as.character(res_boro_ts$borough)

# number of residency by borough (calculated by `by-boro.csv`)
by_boro_URL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/by-boro.csv")
by_boro <- read.csv(text = by_boro_URL)

by_boro_pop <- by_boro %>%
  mutate(population=CASE_COUNT*100000/CASE_RATE) %>%
  select(BOROUGH_GROUP, population) %>%
  filter(BOROUGH_GROUP!="Citywide")
levels(by_boro_pop$BOROUGH_GROUP)[1]='Bronx'
levels(by_boro_pop$BOROUGH_GROUP)[2]='Brooklyn'
levels(by_boro_pop$BOROUGH_GROUP)[3]='Manhattan'
levels(by_boro_pop$BOROUGH_GROUP)[4]='Queens'
levels(by_boro_pop$BOROUGH_GROUP)[5]='Staten Island'
levels(by_boro_pop$BOROUGH_GROUP)[6]='Citywide'
by_boro_pop$BOROUGH_GROUP <- as.character(by_boro_pop$BOROUGH_GROUP)

# case rate (per 100000) by the beginning of phase 2, by borough
boro_case_rate <- boro_cases1 %>%
  left_join(by_boro_pop, by=c("borough"="BOROUGH_GROUP")) %>%
  mutate(case_rate=case_num*100000/population) %>%
  select(borough, case_rate)

boro_case_res_prop <- boro_case_rate %>%
  full_join(res_boro_prop, by=c("borough")) %>%
  arrange(desc(case_rate))

# plot
ay <- list(
  tickfont = list(color = '5c969e'),
  overlaying = "y",
  side = "right",
  title = "Reopened Restaurants %"
)
case_res_bar <- plot_ly() %>% 
  add_bars(data=boro_case_res_prop, x=~borough, y=~case_rate,
           marker = list(color = 'd9e4dd'), name="case rate") %>% 
  add_lines(data=boro_case_res_prop, x=~borough, y=~prop, yaxis='y2',mode='lines',
             line=list(color='5c969e'),name="reopened %") %>%  #marker=list(color='#5bc49f'),
  layout(
  #title = "By the Beginning of Phase 2 Since March", 
  yaxis2 = ay,
  xaxis = list(title=""),
  yaxis = list(title = "Case Rate (per 100,000)"))






# ---------------- Number of cases by age group by boro of interest: Bx, Mn --------------

# Updates daily
age_boroURL <-getURL('https://raw.githubusercontent.com/nychealth/coronavirus-data/master/boro/boroughs-by-age.csv')
all_boros_by_age <- read.csv(text=url3)
boros_by_age <-all_boros_by_age%>%
  select(group, BX_CASE_COUNT, BX_CASE_RATE, MN_CASE_COUNT, MN_CASE_RATE)
  

#--------------------------------------------------------------
# cumulative case rate across phases by borough & citywide
boro_cases2 <- boro_ts_cases %>%
  mutate(date = as.Date(DATE_OF_INTEREST, '%m/%d/%Y')) %>%
  filter(date>='2020-06-08') %>%
  mutate(city_case = rowSums(select(.,MN_CASE_COUNT, QN_CASE_COUNT, BK_CASE_COUNT, BX_CASE_COUNT, SI_CASE_COUNT))) %>%
  rename(mn_case=MN_CASE_COUNT, qn_case=QN_CASE_COUNT, bk_case=BK_CASE_COUNT, bx_case=BX_CASE_COUNT, si_case=SI_CASE_COUNT) %>%
  gather(borough, case_count, mn_case, qn_case, bk_case, bx_case, si_case, city_case) %>%
  mutate(borough=case_when(
    borough=='mn_case'~'Manhattan',
    borough=='qn_case'~'Queens',
    borough=='bk_case'~'Brooklyn',
    borough=='bx_case'~'Bronx',
    borough=='si_case'~'Staten Island',
    borough=='city_case'~'Citywide'
  )) %>%
  select(date, borough, case_count) %>%
  mutate(phase = case_when(
    date >= '2020-06-08' & date <'2020-06-22' ~ 'phase1',
    date >= '2020-06-22' & date <'2020-07-06' ~ 'phase2',
    date >= '2020-07-06' & date <'2020-07-20' ~ 'phase3',
    date >= '2020-07-20' & date <'2020-08-03' ~ 'phase4-1',
    date >= '2020-08-03' & date <'2020-08-17' ~ 'phase4-2',
    date >= '2020-08-17' & date <'2020-08-31' ~ 'phase4-3',
    date >= '2020-08-31' & date <'2020-09-14' ~ 'phase4-4',
    date >= '2020-09-14' & date <'2020-09-30' ~ 'phase4-5',
    date >= '2020-09-30' ~ 'phase4-indoor',
  )) %>%
  group_by(borough, phase) %>%
  summarise(case_count=sum(case_count))

by_boro_pop <- by_boro %>%
  mutate(population=CASE_COUNT*100000/CASE_RATE) %>%
  select(BOROUGH_GROUP, population)

by_boro_pop$BOROUGH_GROUP <- as.character(by_boro_pop$BOROUGH_GROUP)


boro_phase_cases <- boro_cases2 %>%
  left_join(by_boro_pop, by=c("borough"="BOROUGH_GROUP")) %>%
  mutate(case_rate=case_count*100000/population) %>%
  select(phase, borough, case_rate) %>%
  spread(borough, case_rate)

# plot borough case rate since reopen
boro_phase <- plot_ly(data=boro_phase_cases, x=~phase) %>% 
  add_trace(y = ~Manhattan, type = 'scatter', mode = 'lines', 
            line = list(color = '#60acfc', width = 1.5), name='Manhattan',
            hovertemplate = paste('case rate: %{y:.2f}')) %>%
  add_trace(y = ~Bronx, type = 'scatter', mode = 'lines', 
            line = list(color = '#32d3eb', width = 1.5), name='Bronx',
            hovertemplate = paste('case rate: %{y:.2f}')) %>%
  add_trace(y = ~Brooklyn, type = 'scatter', mode = 'lines', 
            line = list(color = '#5bc49f', width = 1.5), name='Brooklyn',
            hovertemplate = paste('case rate: %{y:.2f}')) %>%
  add_trace(y = ~Queens, type = 'scatter', mode = 'lines', 
            line = list(color = '#feb64d', width = 1.5), name='Queens',
            hovertemplate = paste('case rate: %{y:.2f}')) %>%
  add_trace(y = ~`Staten Island`, type = 'scatter', mode = 'lines', 
            line = list(color = '#ff7c7c', width = 1.5), name='Staten Island',
            hovertemplate = paste('case rate: %{y:.2f}')) %>%
  add_trace(y = ~Citywide, type = 'scatter', mode = 'lines', 
            line = list(color = 'black', width = 2.5), name='Citywide',
            hovertemplate = paste('case rate: %{y:.2f}')) %>%
  add_trace(x=~c('phase1', 'phase4-indoor'), y=~c(Manhattan[1], Manhattan[9]), type='scatter',
            mode='markers', marker = list(color = '#60acfc', size = 6), showlegend = FALSE) %>%
  add_trace(x=~c('phase1', 'phase4-indoor'), y=~c(Bronx[1], Bronx[9]), type='scatter',
            mode='markers', marker = list(color = '#32d3eb', size = 6), showlegend = FALSE) %>%
  add_trace(x=~c('phase1', 'phase4-indoor'), y=~c(Brooklyn[1], Brooklyn[9]), type='scatter',
            mode='markers', marker = list(color = '#5bc49f', size = 6), showlegend = FALSE) %>%
  add_trace(x=~c('phase1', 'phase4-indoor'), y=~c(Queens[1], Queens[9]), type='scatter',
            mode='markers', marker = list(color = '#feb64d', size = 6), showlegend = FALSE) %>%
  add_trace(x=~c('phase1', 'phase4-indoor'), y=~c(`Staten Island`[1], `Staten Island`[9]), type='scatter',
            mode='markers', marker = list(color = '#ff7c7c', size = 6), showlegend = FALSE) %>%
  add_trace(x=~c('phase1', 'phase4-indoor'), y=~c(Citywide[1], Citywide[9]), type='scatter',
            mode='markers', marker = list(color = 'black', size = 6), showlegend = FALSE) %>%
  layout(#title='Case Rate Across 14 Days Since Reopen', 
         xaxis=list(title = '', ticktext = list('June 8-22, Phase 1', 'June 22-Jul 6, Phase 2', 'Jul 6-20, Phase 3', 'Jul 20-Aug 3, Phase 4', 'Aug 3-17',
                                                'Aug 17-31','Aug 31-Sep 14','Sep 14-30','Sep 30-now, Indoor'),
                    tickvals = list('phase1','phase2','phase3','phase4-1','phase4-2','phase4-3',
                                    'phase4-4','phase4-5','phase4-indoor'),
                    tickmode = "array"), yaxis=list(title='Case Rate (per 100,000)'))


# Get geojson data from NYC Open Health file, convert zip coe
zipcodes <- geojsonio::geojson_read("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/Geography-resources/MODZCTA_2010_WGS1984.geo.json", what = 'sp')
save(zipcodes, file="output/zipcodes.sp")

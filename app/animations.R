

#------------------------------ Animation --------------------------------------------------
#Create animation line plot of proportion by boro
## data preparation
load(file="output/res_dat.RData")
boro_ts_URL <- getURL("https://raw.githubusercontent.com/nychealth/coronavirus-data/master/boro/boroughs-case-hosp-death.csv")
boro_ts_cases <- read.csv(text = boro_ts_URL)


open_res_boro<-res_dat %>%
  mutate(Date = as.Date(time_submit, '%m/%d/%Y')) %>%
  group_by(Date,borough)%>%
  count()%>%
  summarize(n_open_boro=n)%>%
  group_by(borough)%>%
  mutate(prop=n_open_boro/(ifelse(borough=="Manhattan",11248,ifelse(borough=="Queens",6418,
                                                                    ifelse(borough=="Brooklyn",7178,
                                                                           ifelse(borough=="Bronx",2507,1032))))))

new_case_boro<-boro_ts_cases%>%
  mutate(Date = as.Date(DATE_OF_INTEREST, '%m/%d/%Y')) %>%
  summarize(Date,Manhattan=MN_CASE_COUNT,Queen=QN_CASE_COUNT,Brooklyn=BK_CASE_COUNT,
            Bronx=BX_CASE_COUNT,"Staten Island"=SI_CASE_COUNT)%>%
  gather(borough,new_case_count,Manhattan,Queen,Brooklyn,
         Bronx,"Staten Island")%>%
  group_by(Date,borough)%>%
  summarize(n_case_boro=sum(new_case_count))%>%
  group_by(borough)%>%
  mutate(prop=n_case_boro/(ifelse(borough=="Manhattan", 1628701.2,
                                  ifelse(borough=="Queens",2278906.2,
                                         ifelse(borough=="Brooklyn",2582831.7,
                                                ifelse(borough=="Bronx", 1432131.1,476179.1))))))

animation_1<-open_res_boro %>%
  ggplot( aes(x=Date, y=prop, group=borough, color=borough)) +
  theme_bw()+
  geom_line() +
  geom_point() +
  scale_color_viridis(discrete = TRUE) +
  ggtitle("Reopened resturants in each borough from June to October") +
  ylab("Proportion of reopened resturants by borough") +
  xlab("")+
  transition_reveal(Date)
rest_boro_ani<-animate(animation_1, duration = 8,fps = 20, width =1000, height = 300, renderer = gifski_renderer())
anim_save("output/rest_boro_ani.gif")

animation_2<-new_case_boro %>%
  ggplot( aes(x=Date, y=prop, group=borough, color=borough)) +
  theme_bw()+
  geom_line() +
  geom_point() +
  scale_color_viridis(discrete = TRUE) +
  ggtitle("New confirmed cases in each borough from June to October") +
  ylab("Proportion of new confirmed cases by borough") +
  xlab("")+
  transition_reveal(Date)
case_boro_ani<-animate(animation_2, duration = 8,fps = 20, width =1000, height = 300, renderer = gifski_renderer())
anim_save("output/case_boro_ani.gif")


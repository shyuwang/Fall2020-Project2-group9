###############################################################################
############ This file is to clean the restaurant dataset #####################
###############################################################################

# Cleaning outcome:
## 1. Correct the borough
## 2. Shorten variable names
## 3. Select relevant variables, namely 
### "name", "latitude", "longitude", "seating", "address", "alcohol" (qualified alcohol service or not), "postcode", 
### "borough", "time_submit" (time to submit reopen application), "sw_len" (sidewalk length), "sw_width" (sidewalk width), "sw_area" (sidewalk area), 
###  "rw_len" (roadway length), "rw_width" (roadway width), "rw_area" (roadway area)   
### "approved_sw" (approved for sidewalk seating), "approved_rw" (approved for roadway seating)

if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("tibble")) {
  install.packages("tibble")
  library(tibble)
}
if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
}

#-------------------------------------------------------------------------------------
# zip-borough mapping
bronx <- c(10453, 10457, 10460, 10458, 10467, 10468, 10451, 10452, 
           10456, 10454, 10455, 10459, 10474, 10463, 10471, 10466, 
           10469, 10470, 10475, 10461, 10462,10464, 10465, 10472, 10473)
brooklyn <- c(11212, 11213, 11216, 11233, 11238,11209, 11214, 11228,
              11204, 11218, 11219, 11230,11234, 11236, 11239,
              11223, 11224, 11229, 11235, 11201, 11205, 11215, 11217, 11231,
              11203, 11210, 11225, 11226, 11207, 11208, 11211, 11222,
              11220, 11232, 11206, 11221, 11237)
manhattan <- c(10026, 10027, 10030, 10037, 10039, 10001, 10011, 10018, 10019, 10020, 10036,
               10029, 10035, 10010, 10016, 10017, 10022, 10012, 10013, 10014,
               10004, 10005, 10006, 10007, 10038, 10280, 10002, 10003, 10009,
               10021, 10028, 10044, 10065, 10075, 10128, 10023, 10024, 10025,
               10031, 10032, 10033, 10034, 10040)
queens <- c(11361, 11362, 11363, 11364, 11354, 11355, 11356, 11357, 11358, 11359, 11360
            ,11365, 11366, 11367
            ,11412, 11423, 11432, 11433, 11434, 11435, 11436
            ,11101, 11102, 11103, 11104, 11105, 11106
            ,11374, 11375, 11379, 11385
            ,11691, 11692, 11693, 11694, 11695, 11697
            ,11004, 11005, 11411, 11413, 11422, 11426, 11427, 11428, 11429
            ,	11414, 11415, 11416, 11417, 11418, 11419, 11420, 11421
            ,11368, 11369, 11370, 11372, 11373, 11377, 11378)
si <- c(10302, 10303, 10310
        ,10306, 10307, 10308, 10309, 10312
        ,10301, 10304, 10305
        ,10314)

boro <- c(rep("Bronx",length(bronx)),rep("Brooklyn",length(brooklyn)),
          rep("Manhattan",length(manhattan)),rep("Queens",length(queens)),rep("Staten Island",length(si)))
zip <- c(bronx,brooklyn,manhattan,queens,si)
zip_boro <- data.frame(Borough=boro, Zipcode=zip)

# read Open_Restaurant_Applications.csv from data folder
res <- read.csv("../data/Open_Restaurant_Applications.csv",header=TRUE,sep=';')

# the borough in original data has something wrong, fix it using correct zip-borough mapping
res_dat <- res %>%
  mutate(seating=case_when(
    Seating.Interest..Sidewalk.Roadway.Both.=='both'~'sidewalk and roadway',
    Seating.Interest..Sidewalk.Roadway.Both.=='sidewalk'~'sidewalk',
    Seating.Interest..Sidewalk.Roadway.Both.=='roadway'~'roadway',
    Seating.Interest..Sidewalk.Roadway.Both.=='openstreets'~'openstreets'
  )) %>%
  left_join(zip_boro,by=c('Postcode'='Zipcode')) %>%
  mutate(borough=case_when(
    Borough.x!=Borough.y~Borough.y,
    Borough.x==Borough.y~Borough.y,
    is.na(Borough.y)~Borough.x)) %>%
  select(Restaurant.Name, Latitude, Longitude, seating, 
         Business.Address, Qualify.Alcohol, Postcode, borough,Time.of.Submission,
         Sidewalk.Dimensions..Length.,Sidewalk.Dimensions..Width.,Sidewalk.Dimensions..Area.,
         Roadway.Dimensions..Length.,Roadway.Dimensions..Width.,Roadway.Dimensions..Area.,
         Approved.for.Sidewalk.Seating,Approved.for.Roadway.Seating) %>%
  #filter(!is.na(Latitude) | !is.na(Longitude)) %>%
  rename(longitude=Longitude, latitude=Latitude, name=Restaurant.Name,
         address=Business.Address, alcohol=Qualify.Alcohol, postcode=Postcode,
         time_submit=Time.of.Submission,sw_len=Sidewalk.Dimensions..Length.,sw_width=Sidewalk.Dimensions..Width.,
         sw_area=Sidewalk.Dimensions..Area.,rw_len=Roadway.Dimensions..Length.,rw_width=Roadway.Dimensions..Width.,
         rw_area=Roadway.Dimensions..Area.,approved_sw=Approved.for.Sidewalk.Seating,approved_rw=Approved.for.Roadway.Seating) %>%
  distinct() 

save(res_dat, file="output/res_dat.RData")

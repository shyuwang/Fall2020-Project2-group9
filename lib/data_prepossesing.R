quick_update <- read.csv('../data/coronavirus-data-master/summary.csv')
save(quick_update, file="../app/output/quick_update.RData")

zcta_to_modzcta <- read.csv('../data/coronavirus-data-master/Geography-resources/ZCTA-to-MODZCTA.csv')
save(zcta_to_modzcta, file="../app/output/zcta_to_modzcta.RData")

data_by_modzcta <- read.csv('../data/coronavirus-data-master/data-by-modzcta.csv')
save(data_by_modzcta, file="../app/output/data_by_modzcta.RData")

recent_cases <- read.csv('../data/coronavirus-data-master/recent/recent-4-week-by-modzcta.csv')
save(recent_cases, file="../app/output/recent_cases.RData")

boro_ts_cases <- read.csv('../data/coronavirus-data-master/boro/boroughs-case-hosp-death.csv')
save(boro_ts_cases, file="../app/output/boro_ts_cases.RData")

by_boro <- read.csv('../data/coronavirus-data-master/by-boro.csv')
save(by_boro, file="../app/output/by_boro.RData")

all_boros_by_age <- read.csv('../data/coronavirus-data-master/boro/boroughs-by-age.csv')
save(all_boros_by_age, file="../app/output/all_boros_by_age.RData")

by_pov <- read.csv('../data/coronavirus-data-master/by-poverty.csv')
save(by_pov, file="../app/output/by_pov.RData")
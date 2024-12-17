# Preparing data - not needed unless new data coming through
library(tidyr)
library(dplyr)

filepath <- "/PHI_conf/ScotPHO/Website/Charts/Health Conditions/Allergic Conditions/"

data_allergy <- readRDS(paste0(filepath, "allergy_scotland_chart.rds")) |> 
  mutate(rate = round(rate, 1), # round numbers more (one decimal place)
         numerator = case_when(numerator < 5 ~ NA_real_,
                               TRUE ~ numerator))  |>   # supression of under 5
  gather(measure, value, -c(type, year))  |> 
  mutate(measure = recode(measure, "numerator" = "Number", "rate" = "Rate"))

saveRDS(data_allergy, paste0(filepath, "allergy_scotland_chart.rds"))

## END

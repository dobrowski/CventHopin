

library(tidyverse)
library(here)
library(janitor)

cvent <- read_csv(here("new", "Registration Report_CISC 2022.csv"))


hopin <- cvent %>%
  transmute(Email = `Email Address`,
         FirstName = `First Name`,
         LastName = `Last Name`,
         Headline = Title,
         `optional question 1` = `Company Name`,
         `optional question 2` = `What is your CCSESA Region? If unsure, please visit: https://ccsesa.org/regions/`,
         ticket = case_when(str_detect(`Registration Type`,"Sponsor") ~ "Sponsors",
                            str_detect(`Registration Type`,"Invited") ~ "Speakers",
                            str_detect(`Admission Item`, "Virtual") ~ "Virtual",
                            str_detect(`Admission Item`, "Person") ~ "In Person"
                            
           
         )
         )


hopin %>% 
  group_by(ticket) %>% 
  group_walk(~ write_csv(.x, paste0(.y$ticket, ".csv")))



library(tidyverse)
library(here)
library(janitor)


recent.new <- file.info(list.files(here("new"), full.names = T))
newest.file <- rownames(recent.new)[which.max(recent.new$mtime)]

recent.old <- file.info(list.files(here("old"), full.names = T))
newest.old.file <- rownames(recent.old)[which.max(recent.old$mtime)]
  


# cvent <- read_csv(here("new", "Registration Report_CISC 2022.csv"))
new.file <- read_csv(newest.file)
old.file <- read_csv(newest.old.file)

cvent <- anti_join(new.file,old.file)


hopin <- cvent %>%
  transmute(Email = `Email Address`,
         FirstName = `First Name`,
         LastName = `Last Name`,
         Headline = paste0(Title," - ",`Company Name`),
         `optional question 1` = `Confirmation Number`,
         `optional question 2` = `What is your CCSESA Region? If unsure, please visit: https://ccsesa.org/regions/`,
         ticket = case_when(str_detect(`Registration Type`,"Sponsor") ~ "Sponsors",
                            str_detect(`Registration Type`,"Invited") ~ "Speakers",
                            str_detect(`Admission Item`, "Virtual") ~ "Virtual",
                            str_detect(`Admission Item`, "Person") ~ "In Person"
                            
           
         )
         )


hopin %>% 
  group_by(ticket) %>% 
  group_walk(~ write_csv(.x, here("to_upload", paste0(.y$ticket, Sys.time() ,".csv"))))


#  Add date to file 
#  Deduplicate from previous list first 

file.rename(from = newest.file,
            to = here("old", paste0("Registration Report_CISC 2022", Sys.time() ,".csv"))
)


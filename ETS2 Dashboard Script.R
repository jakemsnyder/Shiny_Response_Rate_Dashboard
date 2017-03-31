library(tidyverse)
library(qualtRics)

setwd('~/Documents/Shiny/ETS2Dashboard')
# API key using .Renviron
# Read Appendix: Storing API Authentication Keys/Tokens at 
# https://github.com/hadley/httr/blob/master/vignettes/api-packages.Rmd for details
registerApiKey(API.TOKEN = Sys.getenv("QUALTRICS_TOKEN"))

# Pull survey data through API
qualtrics.df <- getSurvey(surveyID = Sys.getenv("ETS2_Travel_Survey"), root_url = Sys.getenv("QUALTRICS_URL"),verbose=T)

# Get a list of survey IDs
# getSurveys(root_url=Sys.getenv("QUALTRICS_URL"))

# Response Rate variables
variables <- c('RecipientEmail','Finished')
df <- qualtrics.df[,(names(qualtrics.df) %in% variables)]
df <- df %>% mutate(Finished=as.numeric(Finished)) %>% filter(Finished==1 & RecipientEmail != '') %>% as.data.frame()


# Bring in the contact list used to send the survey
recipients <- read.csv('~/Documents/ETS2/2017 ETS2 Recipient List.csv',stringsAsFactors = F)
recipients <- recipients %>%
  select(Email,
         Agency,
         Vendor.System)

data2 <- left_join(recipients,df,by=c('Email'='RecipientEmail'))

data2 <- data2 %>% mutate(Finished=ifelse(!is.na(Finished),1,0)) %>% select(-Email)
write.csv(data2,'data.csv',row.names=F)

# Create last updated time
update <- format(Sys.time(),tz='America/New_York')
write.table(update,file='LastUpdate.txt',quote=F,row.names=F,col.names=F)
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


# Bring in the contact list(s) used to send the survey
recipients <- read.csv('~/Documents/ETS2/2017 ETS2 Recipient List.csv',stringsAsFactors = F)
recipients2 <- read.csv('~/Documents/ETS2/2017 E2 Second Sample.csv',stringsAsFactors = F)
recipients <- rbind(recipients,recipients2)
recipients <- recipients %>%
  # Clean agency list
  mutate(Agency = ifelse(Agency=='Department of Commerce','DOC - Department of Commerce',Agency)) %>%
  mutate(Agency = ifelse(Agency=='Department Of State','DOS - Department Of State',Agency)) %>%
  mutate(Agency = ifelse(Agency=='Department Of Transportation','DOT - Department Of Transportation',Agency)) %>%
  mutate(Agency = ifelse(Agency=='Dept Of Education','ED - Department of Education',Agency)) %>%
  mutate(Agency = ifelse(Agency=='Dept Of Labor','DOL - Department of Labor',Agency)) %>%
  mutate(Agency = ifelse(Agency=='Equal Employment Opportunity Commission','EEOC - Equal Employment Opportunity Commission',Agency)) %>%
  mutate(Agency = ifelse(Agency=='Federal Trade Commission','FTC - Federal Trade Commission',Agency)) %>%
  mutate(Agency = ifelse(Agency=='National Labor Relations Board','NLRB - National Labor Relations Board',Agency)) %>%
  mutate(Agency = ifelse(Agency=='National Transportation Safety Board','NTSB - National Transportation Safety Board',Agency)) %>%
  mutate(Agency = ifelse(Agency=='Social Security Administration','SSA - Social Security Administration',Agency)) %>%
  select(Email,
         # Add any demographic variables here
         Agency,
         Vendor.System)

data2 <- left_join(recipients,df,by=c('Email'='RecipientEmail'))

data2 <- data2 %>% mutate(Finished=ifelse(!is.na(Finished),1,0)) %>% select(-Email)
write.csv(data2,'data.csv',row.names=F)

# Create last updated time
update <- format(Sys.time(),tz='America/New_York')
write.table(update,file='LastUpdate.txt',quote=F,row.names=F,col.names=F)
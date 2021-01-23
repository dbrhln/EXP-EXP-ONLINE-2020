###### Clean experiment json data #######

rm(list = ls())

library(dplyr)
library(readtext)
library(jsonlite)

wkfolder <- "/Users/deborahlin/Downloads/Exp-Exp-Online-master/download"
setwd(wkfolder)

mydata <- readtext("mydata.json",text_field = "content")
alldatalist <- list()
for (i in 1:nrow(mydata)){
  #need to select appropriate data
  alldatalist[[i]] <- data.frame(fromJSON(txt=mydata$text[i],flatten=TRUE,simplifyDataFrame=TRUE)) %>%
                      #select(rt,stimulus, key_press,trial_event,trial_type,trial_index,time_elapsed,subject) %>%
                      mutate(subject=as.character(subject))
}

alldata <- do.call(bind_rows,alldatalist)
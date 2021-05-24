###### Clean experiment json data
## Load and process json files
## Clean to be like previous experiment data

rm(list = ls())

library(dplyr)
library(stringr)
library(magrittr)
library(readtext)
library(jsonlite)

wkfolder = "/Users/deborahlin/Dropbox/Experiments\ -\ Deborah/2017\ EXP-EXP/EXP-EXP-ONLINE-2020/download/"
setwd(wkfolder)

mydata = readtext("mydata.json",text_field = "content")
alldatalist = list()
for (i in 1:nrow(mydata)) {
  alldatalist[[i]] = data.frame(fromJSON(txt = mydata$text[i],flatten = TRUE,simplifyDataFrame = TRUE))
}

alldata = do.call(bind_rows,alldatalist)

####################################
## Data cleaning

#Extract trial/SS data
alldata_trial <- alldata %>% filter(trial_type == "rdk") %>% select(!c(matches("dot|aperture|frame|fixation|canvas|border",perl=TRUE),
                                                                      move_distance,background_color,reinsert_type)) #Note - need to check if practice excluded
alldata_stayswitch <- alldata %>% filter(trial_event == "Patch selection") %>% select(subject,blkNumber,rt)

#Form master from trial data
alltrialdata <- alldata_trial %>% rename("sub"="subject","blk"="blkNumber","whichPatch"="trial_event","direction"="coherent_direction","resp"="response","corrResp"="correct_choice",
                                     "acc"="correct","rt1"="rt") %>% select(sub,blk,whichPatch,direction,resp,corrResp,acc,rt1,coherence,coh_alt) %>% 
                              group_by(sub,blk) %>% mutate(trial = row_number()) %>% ungroup() %>%
                              mutate(resp = case_when(resp == "FALSE" ~ "NA" , TRUE ~ resp)) %>%
                              mutate(direction=unlist(direction))%>%
                              relocate(sub,blk,trial,whichPatch,coherence,direction,resp,corrResp,acc,rt1,coh_alt)

#Form stayswitch RT data
ssdata <- alldata_stayswitch %>% rename("sub"="subject","blk"="blkNumber","rt2"="rt") %>% group_by(sub,blk) %>% mutate(trial = row_number()) %>% ungroup()

#Merge ss RT data
alltrialdata %<>% left_join(ssdata,by = c("sub","blk","trial"))

#Generate SS choice
alltrialdata %<>% group_by(sub,blk) %>% mutate(stay = (whichPatch == lead(whichPatch,order_by = trial))) %>% mutate(stay = case_when(trial == 20 ~ NA , TRUE ~ stay))

#Separate out experiment vs practice
trialdata_practice <- alltrialdata %>% filter(whichPatch == "Practice") %>% select(!c(coh_alt,rt2,stay))
trialdata_experiment <- alltrialdata %>% filter(whichPatch != "Practice")

#Add conditions to experiment 
#Odd bug with difference variable -> unique(..$difference) with simple abs(coherence-coh_alt) spits out 0.1 0.1 0.2 0.2
trialdata_experiment <- trialdata_experiment %>% mutate(difference=as.numeric(as.character(abs(coherence-coh_alt))),level=rowMeans(cbind(coherence,coh_alt)))

## Get subject level data
#trial_index == 9 -> virtual chinrest result
alldata_subject <- alldata %>% filter((trial_type == "survey-multi-choice" | trial_type == "survey-text" | trial_event == "final_debrief" | trial_index==9)) %>%
                              select(subject,stimulus,responses,trial_type,trial_index) %>% mutate(bonus=NA,age=NA,gender=NA,vision=NA,colorblind=NA,distance=NA)

for (ii in 1:nrow(alldata_subject)) {
  if (alldata_subject$trial_type[ii] == "survey-text") {
    resp_agegender <- fromJSON(alldata_subject$responses[ii])
    alldata_subject$age[ii] <- resp_agegender$Age
    alldata_subject$gender[ii] <- resp_agegender$Gender
  } else if (alldata_subject$trial_type[ii] == "survey-multi-choice") {
    resp_vision <- fromJSON(alldata_subject$responses[ii])
    alldata_subject$vision[ii] <- resp_vision$Vision
    alldata_subject$colorblind[ii] <- resp_vision$Colorblind
  } else if (alldata_subject$trial_index[ii]==9){
    alldata_subject$distance[ii] <- as.numeric(str_extract_all(alldata_subject$stimulus[ii],"(?<=screen is)(\\s+)([0-9.]+)"))
  } else if (!is.na(alldata_subject$stimulus[ii])) {
    alldata_subject$bonus[ii] <- as.numeric(str_extract_all(alldata_subject$stimulus[ii],"(?<=bonus of\\s\\$)([0-9.]+)"))
  } 
}

alldata_subject %<>% select(subject,bonus,age,gender,vision,colorblind,distance)

#Summary of subject no. with bonus, age, gender, normal/corrected vision, colourblind, distance as measured by virtual chinrest
subjectdata <- alldata_subject %>% select(subject,bonus) %>% filter(!is.na(bonus)) %>%
                    left_join(alldata_subject %>% select(subject,age,gender) %>% filter(age != "<NA>"),by = c("subject")) %>%
                    left_join(alldata_subject %>% select(subject,vision,colorblind) %>% filter(vision != "<NA>"),by = c("subject")) %>%
                    left_join(alldata_subject %>% select(subject,distance) %>% filter(distance != "<NA>"),by = c("subject"))
###########################################
#search for entry
subjectdata[subjectdata$subject=="dots_rA29YyDm8w",]

##MYSTERY CODES##
#checking batch file
batch <- read.csv("/Users/deborahlin/Downloads/Batch_4315620_batch_results.csv",header=TRUE)
batch2 <- read.csv("/Users/deborahlin/Downloads/Batch_4312789_batch_results.csv",header=TRUE) #first 9
allbatch <- rbind(batch,batch2)

real <- vector(length=length(batch$Answer.surveycode))
for (i in 1:length(batch$Answer.surveycode)){
  real[i] <- batch$Answer.surveycode[i] %in% subjectdata$subject  
}

unmatched_turk <- batch$Answer.surveycode[c(22,41,49,63)]
#"A2V27A9GZA1NR2"  "dots_hhpDUxFYLK" "dots_7TMTbxXGGk" "dots_rA29YyDm8w"
matched_codes <- vector(length=length(subjectdata$subject))
for (i in 1:length(subjectdata$subject)){
  matched_codes[i] <- subjectdata$subject[i] %in% allbatch$Answer.surveycode
}

unmatched_codes <- subjectdata$subject[c(25,32)]
#"dots_2EkaA4lRFp" "dots_M4rnT8aoA4"

###########################################

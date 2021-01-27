#Preview of averaged results from trialdata_practice and trialdata_experiment
library(ggplot2)
library(tidyverse)

######################################################################
########################### PRACTICE BLOCK ########################### 
######################################################################

#Plot Accuracy By Coherence (coloured by subject id); excluding 0.8 coherence in practice
data_summary <- function(x) {
  m <- mean(x)
  ymin <- m-1.96*(sd(x) / sqrt(length(x)))
  ymax <- m+1.96*(sd(x) / sqrt(length(x)))
  return(c(y=m,ymin=ymin,ymax=ymax))
}

plotTraining_accuracy <- aggregate(trialdata_practice$acc,by=list(trialdata_practice$sub,trialdata_practice$coherence),mean) %>%
      rename("Sub"="Group.1","Coherence"="Group.2","Accuracy"="x") %>%
      filter(Coherence!=0.8) %>%
      ggplot(aes(x=Coherence,y=Accuracy,col=Sub)) +
      geom_jitter(aes(alpha=0.8),position=position_jitter(width=0.02)) + theme_bw() + theme(legend.position="none")

plotTraining_accuracy + stat_summary(fun.data=data_summary, color="black")

#Plot RT By Coherence (coloured by subject id); excluding 0.8 coherence in practice

plotTraining_RT <- aggregate(trialdata_practice$rt1,by=list(trialdata_practice$sub,trialdata_practice$coherence),mean) %>%
  rename("Sub"="Group.1","Coherence"="Group.2","RT"="x") %>%
  filter(Coherence!=0.8) %>%
  ggplot(aes(x=Coherence,y=RT,col=Sub)) +
  geom_jitter(aes(alpha=0.8),position=position_jitter(width=0.02)) + theme_bw() + theme(legend.position="none")

plotTraining_RT + stat_summary(fun.data=data_summary, color="black")

#To see overall RT distribution
#hist(trialdata_practice$rt1)
  


########################################################################
########################### EXPERIMENT BLOCK ########################### 
########################################################################
##LABELS##
cond.labs <- c("Low Diff, M = 0.15","High Diff, M = 0.2","High Diff, M = 0.3", "Low Diff, M = 0.35")
names(cond.labs) <- c("0.15","0.2","0.3","0.35")

stay.labs <- c("Switch","Stay")
names(stay.labs) <- c("FALSE","TRUE")

diff.labs = c("Low","High")
names(diff.labs) <- c(0.1,0.2)
##########

#P(Stay) Over Trials
plotExp_PStay_Trial <- aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$sub,trialdata_experiment$trial),mean) %>%
  rename("Sub"="Group.1","Trial"="Group.2","PropStay"="x") %>%
  filter(Trial!=20) %>%
  ggplot(aes(x=Trial,y=PropStay,col=Sub)) +
  geom_jitter(aes(alpha=0.8),position=position_jitter(width=0.1)) + theme_bw() + theme(legend.position="none")

plotExp_PStay_Trial + stat_summary(fun.data=data_summary, color="black")

#RT Over Trials
plotExp_RT_Trial <- aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$sub,trialdata_experiment$trial,trialdata_experiment$stay),mean) %>%
  rename("Sub"="Group.1","Trial"="Group.2","Stay"="Group.3","RT"="x") %>%
  filter(Trial!=20) %>%
  ggplot(aes(x=Trial,y=RT,col=Sub)) +
  geom_jitter(aes(alpha=0.8),position=position_jitter(width=0.1)) + theme_bw() + theme(legend.position="none") +
  facet_grid(Stay~.,labeller=labeller(Stay=stay.labs))

plotExp_RT_Trial + stat_summary(fun.data=data_summary, color="black")

#P(Stay) in High difference (10v30, 20v40) vs Low difference (10v20, 30v40)

plotExp_PStay_Difference <- aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$sub,as.factor(trialdata_experiment$difference)),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Difference"="Group.2","PropStay"="x") %>%
  ggplot(aes(x=Difference,y=PropStay,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  scale_x_discrete(breaks=c(0.1,0.2),labels=c("Low","High"))+
  theme_bw() + theme(legend.position="none")

plotExp_PStay_Difference + stat_summary(fun.data=data_summary, color="black")
# 
# ###BY TRIAL
# plotExp_PStay_Trial_Difference <- aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$sub,trialdata_experiment$trial,trialdata_experiment$difference),mean) %>%
#   rename("Sub"="Group.1","Trial"="Group.2","Difference"="Group.3","PropStay"="x") %>%
#   filter(Trial!=20) %>%
#   ggplot(aes(x=Trial,y=PropStay,col=Sub)) +
#   geom_jitter(aes(alpha=0.8),position=position_jitter(width=0.1)) + theme_bw() + theme(legend.position="none") +
#   facet_grid(Difference~.,labeller=labeller(Difference=diff.labs))
# 
# plotExp_PStay_Trial_Difference + stat_summary(fun.data=data_summary, color="black")
# 
#RT(for stay + switch) in High difference vs Low difference
plotExp_RT_Difference <- aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$sub,as.factor(trialdata_experiment$difference)),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Difference"="Group.2","RT"="x") %>%
  ggplot(aes(x=Difference,y=RT,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  scale_x_discrete(breaks=c(0.1,0.2),labels=c("Low","High"))+
  theme_bw() + theme(legend.position="none")

plotExp_RT_Difference + stat_summary(fun.data=data_summary, color="black")
# 
# ##BY TRIAL
# plotExp_RT_Trial_Difference <- aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$sub,trialdata_experiment$trial,trialdata_experiment$stay, trialdata_experiment$difference),mean) %>%
#   rename("Sub"="Group.1","Trial"="Group.2","Stay"="Group.3","Difference"="Group.4","RT"="x") %>%
#   filter(Trial!=20) %>%
#   ggplot(aes(x=Trial,y=RT,col=Sub)) +
#   geom_jitter(aes(alpha=0.8),position=position_jitter(width=0.1)) + theme_bw() + theme(legend.position="none") +
#   facet_grid(Stay~Difference,labeller=labeller(Stay=stay.labs,Difference=diff.labs))
# 
# plotExp_RT_Trial_Difference + stat_summary(fun.data=data_summary, color="black")

#P(Stay) across mean difficulty levels
plotExp_PStay_Level <- aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$sub,as.factor(trialdata_experiment$level)),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Level"="Group.2","PropStay"="x") %>%
  ggplot(aes(x=Level,y=PropStay,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  theme_bw() + theme(legend.position="none")

plotExp_PStay_Level + stat_summary(fun.data=data_summary, color="black")

###BY TRIAL
#aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$trial,trialdata_experiment$level),FUN = function(x) cbind(m = mean(x,na.rm=TRUE), std = sd(x,na.rm=TRUE))) 
plotExp_PStay_Trial_Level <- aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$trial,trialdata_experiment$level),mean,na.rm=TRUE) %>%
  mutate(std=aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$trial,trialdata_experiment$level),sd,na.rm=TRUE)$x)%>%
  rename("Trial"="Group.1","Level"="Group.2","PStay"="x","std"="std") %>%
  filter(Trial!=20) %>%
  ggplot(aes(x=Trial,y=PStay)) +
  geom_point(aes(alpha=0.8),position=position_jitter(width=0.1)) + geom_line(aes(alpha=0.8),linetype="dashed")+
  geom_errorbar(aes(ymin=PStay-std, ymax=PStay+std), width=.2)+
  theme_bw() + theme(legend.position="none") +
  facet_grid(Level~.,labeller=labeller(Level=cond.labs))

#RT(for stay + switch) across mean difficulty levels
plotExp_RT_Level <- aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$sub,as.factor(trialdata_experiment$level)),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Level"="Group.2","RT"="x") %>%
  ggplot(aes(x=Level,y=RT,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  theme_bw() + theme(legend.position="none")

plotExp_RT_Level + stat_summary(fun.data=data_summary, color="black")

##BY TRIAL
plotExp_RT_Trial_Level <- aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$trial,trialdata_experiment$stay, trialdata_experiment$level),mean) %>%
  mutate(std=aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$trial,trialdata_experiment$stay, trialdata_experiment$level),mean)$x) %>%
  rename("Trial"="Group.1","Stay"="Group.2","Level"="Group.3","RT"="x","std"="std") %>%
  filter(Trial!=20) %>%
  ggplot(aes(x=Trial,y=RT)) +
  geom_point(aes(alpha=0.8),position=position_jitter(width=0.1)) + geom_line(aes(alpha=0.8),linetype="dashed")+
  geom_errorbar(aes(ymin=RT-std, ymax=RT+std), width=.2)+
  theme_bw() + theme(legend.position="none")+
  facet_grid(Stay~Level,labeller=labeller(Stay=stay.labs,Level=cond.labs))

plotExp_RT_Trial_Level

#PStay as a function of accuracy for various conditions
##Overall
plotExp_PStay_Acc <- aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$sub,trialdata_experiment$acc),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Acc"="Group.2","PStay"="x") %>%
  ggplot(aes(x=Acc,y=PStay,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  theme_bw() + theme(legend.position="none")
  #facet_grid(Stay~Level,labeller=labeller(Stay=stay.labs))

plotExp_PStay_Acc + stat_summary(fun.data=data_summary, color="black")

##Conditions
plotExp_PStay_Acc_Cond <- aggregate(trialdata_experiment$stay,by=list(trialdata_experiment$sub,trialdata_experiment$acc,trialdata_experiment$level,trialdata_experiment$coherence),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Acc"="Group.2","Level"="Group.3","Coherence"="Group.4","PStay"="x") %>%
  ggplot(aes(x=Acc,y=PStay,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  theme_bw() + theme(legend.position="none")+
  facet_grid(.~Level+Coherence,labeller=labeller(Level=cond.labs))

plotExp_PStay_Acc_Cond + stat_summary(fun.data=data_summary, color="black")

#RT (Stay & Switch) as a function of accuracy for various conditions
##Overall
plotExp_RT_Acc <- aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$sub,trialdata_experiment$acc),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Acc"="Group.2","RT"="x") %>%
  ggplot(aes(x=Acc,y=RT,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  theme_bw() + theme(legend.position="none")
#facet_grid(Stay~Level,labeller=labeller(Stay=stay.labs))

plotExp_RT_Acc + stat_summary(fun.data=data_summary, color="black")

#Conditions
plotExp_RT_Acc_Cond <- aggregate(trialdata_experiment$rt2,by=list(trialdata_experiment$sub,trialdata_experiment$acc,trialdata_experiment$level,trialdata_experiment$coherence,trialdata_experiment$stay),mean,na.rm=TRUE) %>%
  rename("Sub"="Group.1","Acc"="Group.2","Level"="Group.3","Coherence"="Group.4","Stay"="Group.5","RT"="x") %>%
  ggplot(aes(x=Acc,y=RT,col=Sub)) +
  geom_point(aes(alpha=0.8,group=Sub)) + geom_line(aes(alpha=0.8, group=Sub),linetype="dashed") +
  theme_bw() + theme(legend.position="none")+
  facet_grid(Stay~Level+Coherence,labeller=labeller(Stay=stay.labs,Level=cond.labs))

plotExp_RT_Acc_Cond + stat_summary(fun.data=data_summary, color="black")


########################################################################
############################ GENERATE PDFS #############################
########################################################################

#Save PDF with training data plots
pdf("Training_Plots.pdf",bg="transparent")
plotTraining_accuracy + stat_summary(fun.data=data_summary, color="black")
plotTraining_RT + stat_summary(fun.data=data_summary, color="black")
dev.off()

#Save PDF with experiment data plots
pdf("Experiment_Plots.pdf",bg="transparent",width=12,height=8)
plotExp_PStay_Trial + stat_summary(fun.data=data_summary, color="black")+labs(title="P(Stay) over Trials")
plotExp_RT_Trial + stat_summary(fun.data=data_summary, color="black")+labs(title="RT over Trials")
plotExp_PStay_Difference + stat_summary(fun.data=data_summary, color="black")+labs(title="P(Stay) over Difference in Coherence")
#plotExp_PStay_Trial_Difference + stat_summary(fun.data=data_summary, color="black")+labs(title="P(Stay) over Trials and Difference in Coherence")
plotExp_RT_Difference + stat_summary(fun.data=data_summary, color="black")+labs(title="RT over Difference in Coherence")
#plotExp_RT_Trial_Difference + stat_summary(fun.data=data_summary, color="black")+labs(title="RT over Trials and Difference in Coherence")
plotExp_PStay_Level + stat_summary(fun.data=data_summary, color="black")+labs(title="P(Stay) over Mean Levels of Coherence")
plotExp_PStay_Trial_Level + stat_summary(fun.data=data_summary, color="black")+labs(title="P(Stay) over Trials and Mean Levels of Coherence")
plotExp_RT_Level + stat_summary(fun.data=data_summary, color="black")+labs(title="RT over Mean Levels of Coherence")
plotExp_RT_Trial_Level + stat_summary(fun.data=data_summary, color="black")+labs(title="RT over Trials and Mean Levels of Coherence")
plotExp_PStay_Acc + stat_summary(fun.data=data_summary, color="black")+labs(title="P(Stay) against RDK Accuracy")
plotExp_PStay_Acc_Cond + stat_summary(fun.data=data_summary, color="black")+labs(title="P(Stay) against RDK Accuracy across Conditions")
plotExp_RT_Acc_Cond + stat_summary(fun.data=data_summary, color="black")+labs(title="Stay-Switch RT against RDK Accuracy across Conditions")
dev.off()
########################################################################

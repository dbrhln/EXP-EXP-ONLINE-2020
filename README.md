# EXP-EXP-ONLINE-2020

This repository contains the relevant scripts for the online version of the experiment for my PhD on exploration and exploitation. In the experiment,
participants are repeatedly asked to choose between two random dot kinematogram (RDK) direction judgment tasks varying in difficulty and obtain a
reward if they do the task correctly. Exploration is operationalised as choosing to do the alternate task on the next trial, and exploitation is
operationalised as choosing to do the same task on the next trial. The mean level of difficulty and difference in difficulty between the two presented RDK tasks are manipulated for this experiment. Direction judgment and stay/switch choices and response times are recorded for every trial.

The entire experiment comprises four parts: (1) a short demographic questionnaire, (2) a measurement task to detect participants' viewing distance
(based on Li, Sung, Yeatman, & Reinecke, 2020), (3) 60 practice trials for the RDK direction judgment task, and (4) main experiment comprising
8 blocks of 20 trials. The experiment was coded in javascript + html/css and hosted on Google App Engine for deployment on Amazon Mechanical Turk. 

The experiment can be viewed [here](https://exp-exp-289600.ts.r.appspot.com/).

## Contents
- *index.html* - experiment
- *virtualchinrest.js* - additional jspsych plugin for the measurement task (a "virtual chinrest")
- *backend.py, app.yaml, bulkbuilder.yaml* - scripts for hosting the experiment on Google App Engine. *backend.py* is for writes to the datastore. *app.yaml*
specifies how URL paths correspond to request handlers and static files. *bulkbuilder.yaml* contains the build properties
- *debrief* - folder containing the debriefing page
- *download* - folder containing downloaded data in json format (*mydata.json*) and scripts for downloading (*downloadall.py*) and cleaning data (*clean_json.R*)
- *jspsych-6.1.0* - js library for running behavioural experiments online (downloaded from www.jspsych.org) and includes an edited resize plugin (*jspsych-resize-noscale.js*)

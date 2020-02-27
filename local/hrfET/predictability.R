##### Environmental Variables #####
# libraries
library(dplyr)
library(readxl)
library(stringr)

#Set the working environment.
HM.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                              "data", "eyetracking", "mri_session")
HRF.DIR <- file.path(HM.DIR, "hrfs")
RP.DIR <- file.path(HM.DIR, "reports")
PT.XL <- read_excel(file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                              "data", "participants", "master.xlsx")
                    ) 


#### Structure Directories ####

#create the directory to hold timing files.
if (file.exists(HRF.DIR)){
  setwd(HRF.DIR)
} else {
  dir.create(HRF.DIR)
  setwd(HRF.DIR)
}

#### Read data ####

#Read in fixation report.
REPORT <- read.delim2(
  file.path(RP.DIR, "test_IAReport.txt"),
  header = TRUE,
  sep = "\t",
  fill = TRUE)

# predictabilities
ORTHOS <- read.csv(file.path("~","Box","LukeLab",
                             "UnderstandingTheProcessOfReading","data",
                             "Provo_Corpus-Eyetracking_Data.csv"), 
                   header = TRUE, sep = ",", fill = TRUE)

# corrections to subject labels
CORS <- read.delim2(
  file.path(RP.DIR, "corrections.txt"),
  header = TRUE,
  sep = "\t",
  fill = TRUE,
  stringsAsFactors = FALSE
)

#### Data cleaning ####
vars <- c("RECORDING_SESSION_LABEL",
          "TRIAL_INDEX",
          "picture",
          "practice",
          "sce_id",
          "scenecondition",
          "stimtype",
          "text",
          "textnumber",
          "trialcount",
          "IA_ID",
          "IA_FIRST_FIXATION_TIME",
          "IA_DWELL_TIME",
          "IA_FIRST_FIXATION_DURATION",
          "IA_SKIP"
          )

REPORT <- REPORT %>%
  select(vars) %>% # only select wanted variables, listed in vars
  filter(
    practice != 1, # remove practice runs
    IA_SKIP == 0
  )


# clean up subject labes
REPORT$RECORDING_SESSION_LABEL <- as.character(REPORT$RECORDING_SESSION_LABEL)
REPORT$textnumber <- as.numeric(
  as.character(REPORT$textnumber)
)

# detect bad session labels
# test <- REPORT %>% 
#   filter(str_detect(RECORDING_SESSION_LABEL, "r\\d(c|d)\\d{3}"))
# 
# goodLabels <- unique(test$RECORDING_SESSION_LABEL)
# 
# 
# badlabels <- unique(
#   REPORT$RECORDING_SESSION_LABEL[
#   !(REPORT$RECORDING_SESSION_LABEL %in% goodLabels)]
# )


# fix bad recording session labels
for (booboo in CORS$RECORDING_SESSION_LABEL) {
  REPORT$RECORDING_SESSION_LABEL[REPORT$RECORDING_SESSION_LABEL == booboo] <-
    CORS$CORRECTION[CORS$RECORDING_SESSION_LABEL == booboo]
}

# add mriID and run number variables
REPORT$mriID <- toupper(REPORT$RECORDING_SESSION_LABEL)
REPORT$mriID <- gsub("R(\\d)(C|D)(\\d{3})",
                     "Luke_nih_\\2\\3",
                     REPORT$mriID)
REPORT$run <- gsub("R(\\d)(C|D)(\\d{3})",
                     "\\1",
                   toupper(REPORT$RECORDING_SESSION_LABEL))

# remove all non-study recording session labels
REPORT <- REPORT[REPORT$mriID %in% unique(PT.XL$mriID),]

# merge fixation report with predictabilities
df <- ORTHOS[c("Text_ID",
               "IA_ID",
               "OrthoMatchModel",
               "POSMatchModel",
               "LSA_Context_Score",
               "Word_Length",
               "Word_Content_Or_Function")] %>% 
  filter(is.na(Word_Length) != TRUE,
         is.na(Word_Content_Or_Function) != TRUE
  ) %>%
  group_by(Text_ID, 
           IA_ID, 
           OrthoMatchModel, 
           Word_Length, 
           Word_Content_Or_Function) %>%
  summarize(
    mean_OrthoMatchModel = mean(OrthoMatchModel)
    ) %>%
  ungroup() %>%
  right_join(REPORT,
             by = c("Text_ID" = "textnumber", 
                    "IA_ID" = "IA_ID")
  )

rm(ORTHOS, REPORT, CORS, PT.XL) # unload superfluous dataframes


#### Make HRF files ####

make_predictability_hrf <- function(report, pred_type, output_directory){
  
}

#remove unneeded columns/values
group = group[group$Content_Or_Function == "Content", ]
group <- group[,c("RECORDING_SESSION_LABEL",
                  "RUN","START_TIME","LSA_Context_Score",
                  "IA_FIRST_RUN_DWELL_TIME")]

#remove NA values form group matrix
group = group[is.na(group$START_TIME) == FALSE, ]

#Create a column with times in parametric format 
# ([event1 start time]*[predictability]:[Duration] ...  [eventn start time]*[LSA]:[Duration]) 
# and perform maths to convert times from milliseconds to seconds.
group$Parametric_times = paste((group$START_TIME/1000),
                               scale(group$LSA_Context_Score), sep = "*")
group$Parametric_times = paste(group$Parametric_times,
                               (group$IA_FIRST_RUN_DWELL_TIME/1000), sep = ":")

mdata = group
colnames(mdata)
mdata <- mdata[c(1,2,6)]
library(reshape2)
mdata <- melt(mdata, id=c("RECORDING_SESSION_LABEL","RUN"))
mdata = mdata[is.na(mdata$RECORDING_SESSION_LABEL) == FALSE, ]

#Assemble the individual AM timing files so that each subject 
# has an individual timing file with one row per run
for (i in unique(mdata$RECORDING_SESSION_LABEL)) {
  sub1data = mdata[mdata$RECORDING_SESSION_LABEL == i, ]
  colnames(sub1data)
  #sub1data = sub1data[order(sub1data$RUN), ]
  if (nrow(sub1data) > 0) {
    sub1data = sub1data[c(2:4)]
    sub1data$variable = 1:nrow(sub1data)
    sub1data[sub1data$RUN == 3, ]$variable = sub1data[sub1data$RUN == 3, ]$variable - max(sub1data[sub1data$RUN == 2, ]$variable)
    sub1data[sub1data$RUN == 2, ]$variable = sub1data[sub1data$RUN == 2, ]$variable - max(sub1data[sub1data$RUN == 1, ]$variable)
    sub1data = dcast(sub1data, RUN ~ variable)
    #max(sub1data[sub1data$RUN == 3, ]$variable)
    sub1data = sub1data[2:ncol(sub1data)]
    write.table(sub1data, paste(i, ".txt", sep = ""), sep = "\t", na = "", col.names = FALSE, row.names = FALSE, quote = FALSE)
    }
}

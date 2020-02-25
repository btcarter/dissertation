#####
# Environmental variables
# libraries
library(dplyr)

#Set the working environment.
HM.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                              "data", "eyetracking", "mri_session")
HRF.DIR <- file.path(HM.DIR, "hrfs")
RP.DIR <- file.path(HM.DIR, "reports")


#####
# Setting the mood

#create the directory to hold timing files.
if (file.exists(HRF.DIR)){
  setwd(HRF.DIR)
} else {
  dir.create(HRF.DIR)
  setwd(HRF.DIR)
}

#####
# Gather the data

#Read in fixation report.
REPORT <- read.delim2(
  file.path(RP.DIR, "test.txt"),
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

#####
# Data cleaning

vars <- c("RECORDING_SESSION_LABEL",
          "TRIAL_INDEX",
          "CURRENT_FIX_DURATION",
          "CURRENT_FIX_START",
          "CURRENT_FIX_INTEREST_AREA_LABEL",
          "practice",
          "sce_id",
          "scenecondition",
          "stimtype",
          "text",
          "textnumber",
          "trialcount")

REPORT <- REPORT %>%
  select(vars) %>% # only select wanted variables, listed in vars
  filter(
    practice != 1  # remove practice runs
  )


# clean up subject labes
REPORT$RECORDING_SESSION_LABEL <- as.character(REPORT$RECORDING_SESSION_LABEL)

for (booboo in CORS$RECORDING_SESSION_LABEL) {
  booboo = "c002"
  REPORT$RECORDING_SESSION_LABEL[REPORT$RECORDING_SESSION_LABEL == booboo] <-
    CORS$CORRECTION[CORS$RECORDING_SESSION_LABEL == booboo]
}

# add mriID and run number variables



# merge fixation report with predictabilities
df <- ORTHOS[c("Text_ID","IA_ID","OrthoMatchModel","Word_Length","Word_Content_Or_Function")] %>% 
  filter(is.na(Word_Length) != TRUE,
         is.na(Word_Content_Or_Function) != TRUE
  ) %>%
  group_by(Text_ID, IA_ID, OrthoMatchModel, Word_Length, Word_Content_Or_Function) %>%
  summarize(mean_OrthoMatchModel = mean(OrthoMatchModel)) %>%
  ungroup() %>%
  right_join(REPORT,
             by = c("Text_ID" = "textnumber", 
                    "IA_ID" = "CURRENT_FIX_INTEREST_AREA_LABEL")
  )

rm(ORTHOS, REPORT) # unload superfluous dataframes


















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

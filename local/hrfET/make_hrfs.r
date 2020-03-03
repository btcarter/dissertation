# Environmental Variables #####
# libraries
library(dplyr)
library(readxl)
library(stringr)
library(reshape2)

#Set the working environment.
HM.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                              "data", "eyetracking", "mri_session")
HRF.DIR <- file.path(HM.DIR, "hrfs")
RP.DIR <- file.path(HM.DIR, "reports")

PT.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                    "data", "participants")
PT.XL <- read_excel(file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                              "data", "participants", "master.xlsx")) 
PT.LIST <- file.path(PT.DIR, "participants.tsv") # name of output file with participant list in it.

RS.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                    "results", "dissertation")

# Structure Directories ####

#create the directory to hold timing files.
if (file.exists(HRF.DIR)){
  setwd(HRF.DIR)
} else {
  dir.create(HRF.DIR)
  setwd(HRF.DIR)
}

# Load data ####

# trial report
TRIAL <- file.path(RP.DIR, "test_Trial")

#Read in interest areas report.
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


# Make participant list for MRI analysis ####
PT.XL <- PT.XL %>%
  filter(
    mriEtGood == TRUE,
    structMri == TRUE,
    !is.na(ctoppRapidDigitError)
  )

write.table(PT.XL$mriID,
            file = PT.LIST, 
            sep = "\t", 
            quote = FALSE,
            col.names = FALSE,
            row.names = FALSE
)

# Predictability Data cleaning ####
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
          "IA_SKIP",
          "IA_FIXATION_COUNT",
          "IA_REGRESSION_IN",
          "IA_FIRST_RUN_DWELL_TIME"
          )

factor_to_numeric <- function(x) {as.numeric(as.character(x))}

REPORT <- REPORT %>%
  select(vars) %>% # only select wanted variables, listed in vars
  filter(
    practice != 1 # remove practice runs
  ) %>%
  mutate(
    "IA_FIRST_FIXATION_TIME" = factor_to_numeric(IA_FIRST_FIXATION_TIME),
    "IA_DWELL_TIME" = factor_to_numeric(IA_DWELL_TIME)/1000,
    "IA_FIRST_FIXATION_DURATION" = factor_to_numeric(IA_FIRST_FIXATION_DURATION),
    "IA_FIXATION_COUNT" = factor_to_numeric(IA_FIXATION_COUNT),
    "IA_REGRESSION_IN" = factor_to_numeric(IA_REGRESSION_IN),
    "IA_FIRST_RUN_DWELL_TIME" = factor_to_numeric(IA_FIRST_RUN_DWELL_TIME)
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
           POSMatchModel,
           LSA_Context_Score,
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

rm(ORTHOS, REPORT) # unload superfluous dataframes

# Make dataframes ####

df_reading <- df %>% filter(
  Word_Content_Or_Function == "Content", # select fixations on content words only
  stimtype == 1 # select only word interest areas
)

df_pictures <- df %>% filter(
  stimtype == 2 # select only picture interest areas
)

# Make AM-HRF files ####

#### predictability hrfs
make_predictability_hrf <- function(report, pred_type, output_directory){
  
  # debugging variables
  # report <- df_reading
  # pred_type <- "LSA_Context_Score"
  # output_directory <- HRF.DIR
  
  
  vars <- c("mriID",
            "run",
            "IA_FIRST_FIXATION_TIME",
            pred_type,
            "IA_DWELL_TIME")
  
  # transform predictability measure if necessary
  if (pred_type == "LSA_Context_Score") {
    report[[pred_type]] <- scale(report[[pred_type]])
  }
 
  #remove unneeded columns/values and convert times
  report <- report %>%
    select(vars) %>%
    filter(IA_SKIP == 0) %>%
    mutate(
      Parametric_times = paste(
        IA_FIRST_FIXATION_TIME,
        "*",
        report[[pred_type]],
        ":",
        IA_DWELL_TIME,
        sep = ""
      )
    ) %>%
    select(
      mriID,
      run,
      Parametric_times
    ) %>%
    melt(
      id=c("mriID","run")
    )
  
  #Assemble the individual AM timing files so that each subject 
  # has an individual timing file with one row per run
  for (i in unique(report$mriID)) {
    
    # debugging
    # i<-"Luke_nih_C001"
    
    sub_data = report[report$mriID == i, ]
    if (nrow(sub_data) > 0) {
      sub_data = sub_data[c(2:4)]
      sub_data$variable = 1:nrow(sub_data)
      sub_data[sub_data$run == 6, ]$variable = 
        sub_data[sub_data$run == 6, ]$variable - 
        max(sub_data[sub_data$run == 5, ]$variable)
      sub_data[sub_data$run == 5, ]$variable = 
        sub_data[sub_data$run == 5, ]$variable - 
        max(sub_data[sub_data$run == 4, ]$variable)
      sub_data[sub_data$run == 4, ]$variable = 
        sub_data[sub_data$run == 4, ]$variable - 
        max(sub_data[sub_data$run == 3, ]$variable)
      sub_data[sub_data$run == 3, ]$variable = 
        sub_data[sub_data$run == 3, ]$variable - 
        max(sub_data[sub_data$run == 2, ]$variable)
      sub_data[sub_data$run == 2, ]$variable = 
        sub_data[sub_data$run == 2, ]$variable - 
        max(sub_data[sub_data$run == 1, ]$variable)
      sub_data = dcast(sub_data, run ~ variable)
      sub_data = sub_data[2:ncol(sub_data)]
      dir.create(file.path(output_directory, pred_type))
      write.table(sub_data, 
                  file.path(output_directory, pred_type, paste(i, ".txt", sep = "")), 
                  sep = "\t", na = "", col.names = FALSE, row.names = FALSE, quote = FALSE)
    }
  }
}

predictabilities <- list("LSA_Context_Score", "OrthoMatchModel", "POSMatchModel")

sapply(predictabilities, 
       make_predictability_hrf, 
       report=df_reading, 
       output_directory=HRF.DIR)

# Block Data Cleaning ####
TRIAL <- read.delim2(
  TRIAL,
  header = TRUE,
  sep = "\t",
  fill = TRUE
)

  # fix bad recording session labels
for (booboo in CORS$RECORDING_SESSION_LABEL) {
  TRIAL$RECORDING_SESSION_LABEL[TRIAL$RECORDING_SESSION_LABEL == booboo] <-
    CORS$CORRECTION[CORS$RECORDING_SESSION_LABEL == booboo]
}

  # add mriID and run number variables
TRIAL$mriID <- toupper(TRIAL$RECORDING_SESSION_LABEL)
TRIAL$mriID <- gsub("R(\\d)(C|D)(\\d{3})",
                     "Luke_nih_\\2\\3",
                     TRIAL$mriID)
TRIAL$run <- gsub("R(\\d)(C|D)(\\d{3})",
                   "\\1",
                   toupper(TRIAL$RECORDING_SESSION_LABEL))

  # remove all non-study recording session labels
TRIAL <- TRIAL[TRIAL$mriID %in% unique(PT.XL$mriID),]

# Make dataframe #
TRIAL %>%
  select(
    RECORDING_SESSION_LABEL,
    INDEX,
    START_TIME
  )

# Make Block-HRFs ####

# lmer model of ET data ####

  # load packages
  library(lme4)
  library(lmerTest)

  # add group labels
  df_read_mod <- df_reading %>%
    right_join(
      PT.XL,
      by = "mriID"
    )

  # do eye tracking summary statistics
  vars_summ <- c("group",
                 "IA_ID",
                 "IA_SKIP",
                 "IA_FIXATION_COUNT",
                 "IA_REGRESSION_IN",
                 "IA_FIRST_FIXATION_DURATION",
                 "IA_DWELL_TIME",
                 "IA_FIRST_RUN_DWELL_TIME")
  
  mean_sd <- function(a) {
    b <- round(mean(a, na.rm = TRUE), digits = 2)
    c <- round(sd(a, na.rm = TRUE), digits = 2)
    return(paste(b," (",c,")",sep=""))
  }
  
  sumStats1 <- df_read_mod %>%
    group_by(group, IA_ID) %>%
    summarise(
      skipping_prob = sum(IA_SKIP)/n(),
      refixation_prob = sum(IA_FIXATION_COUNT >= 2)/n(),
      regression_prob = sum(IA_REGRESSION_IN, na.rm = TRUE)/n()
    ) %>%
    ungroup() %>%
    group_by(windowcondition) %>%
    summarise(
      "Refixation probability" = mean_sd(refixation_prob),
      "Regression probability" = mean_sd(regression_prob)
    ) %>%
    gather(Statistic, Value, "Refixation probability":"Regression probability") %>%
    spread(group, Value)
  
  # first fixation duration, location and dwell time
  sumStats2 <- df_read_mod %>%
    group_by(group) %>%
    summarize(
      "First Fixation Duration" = mean_sd(IA_FIRST_FIXATION_DURATION),
      "Dwell Time" = mean_sd(IA_DWELL_TIME),
      "Gaze Duration" = mean_sd(IA_FIRST_RUN_DWELL_TIME)
    ) %>%
    gather(Statistic, Value, "First Fixation Duration":"Gaze Duration") %>%
    spread(group, Value)
  
  # combine into single table
  sumStats <- rbind(sumStats2,sumStats1)
  
  # do test
  read_mod <- lmer(
    IA_DWELL_TIME ~ as.factor(group) + OrthoMatchModel + (1|run),
    df_read_mod
  )
  
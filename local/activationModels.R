# author: Benjamin Carter
# dyslexia fMRI classification and logistic oculomotor model
#  aka trying to salvage what's left

# Setting the mood ####
# libraries
library(dplyr)
library(readxl)
library(stringr)
library(reshape2)
library(tidyr)
library(lme4)
library(lmerTest)

#Set the working environment.
HM.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                    "data", "eyetracking", "mri_session")

HRF.DIR <- file.path(HM.DIR, "hrfs")

RP.DIR <- file.path(HM.DIR, "reports")

PT.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                    "data", "participants")

PT.XL <- read_excel(file.path(PT.DIR, "master.xlsx")) 

PT.LIST1 <- file.path(PT.DIR, "participants.tsv") # name of output file with participant list in it.

RS.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                    "results", "dissertation")

ROIS <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                 "results", "dissertation", "fMRI", "roiStats")


# Load data ####

# Read in interest areas report.
REPORT <- read.delim2(
  file.path(RP.DIR, "IAReport.txt"),
  header = TRUE,
  sep = "\t",
  fill = TRUE,
  na.strings = ".")

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

# roi stats
ROIS.BLOCK <- read.delim2(file.path(ROIS, "block.txt"),
                         header = TRUE,
                         sep = "\t",
                         fill = TRUE,
                         stringsAsFactors = FALSE
                         )


# OM Data cleaning ####
vars <- c("RECORDING_SESSION_LABEL",
          "TRIAL_INDEX",
          "picture",
          "practice",
          "sce_id",
          "scenecondition",
          "stimtype",
          "textnumber",
          "trialcount",
          "IA_ID",
          "IA_FIRST_FIXATION_TIME",
          "IA_DWELL_TIME",
          "IA_FIRST_FIXATION_DURATION",
          "IA_SKIP",
          "IA_FIXATION_COUNT",
          "IA_REGRESSION_IN",
          "IA_FIRST_RUN_DWELL_TIME",
          "TRIAL_START_TIME",
          "sync_time.1."
)

factor_to_numeric <- function(x) {as.numeric(as.character(x), digits = 15)}

REPORT <- REPORT %>%
  select(vars) %>% # only select wanted variables, listed in vars
  filter(
    practice != 1, # remove practice runs
    IA_SKIP == 0,
    TRIAL_START_TIME > 0
  ) 

# clean up subject labes
REPORT$RECORDING_SESSION_LABEL <- as.character(REPORT$RECORDING_SESSION_LABEL)
REPORT$textnumber <- as.numeric(
  as.character(REPORT$textnumber)
)

# fix bad recording session labels
for (booboo in CORS$RECORDING_SESSION_LABEL) {
  REPORT$RECORDING_SESSION_LABEL[REPORT$RECORDING_SESSION_LABEL == booboo] <-
    CORS$CORRECTION[CORS$RECORDING_SESSION_LABEL == booboo]
}

# add mriID and run number variables
REPORT$mriID <- toupper(REPORT$RECORDING_SESSION_LABEL)
REPORT$mriID <- gsub("R(\\d)(C|D)(\\d{3})",
                     "Luke_Nih_\\2\\3",
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



# ROI data cleaning

ROIS.BLOCK <- ROIS.BLOCK[-c(48,49),]

remove_even_rows <- function(x){
  row_array <- 2:nrow(x)
  even_rows <- row_array %% 2
  x <- x[even_rows == 0,]
  return(x)
}

ROIS.BLOCK <- remove_even_rows(ROIS.BLOCK)
ROIS.BLOCK$mriID <-
  gsub("\\/fslhome\\/ben88\\/compute\\/NihReadingStudy\\/functional\\/Luke_Nih_(C|D)(\\d{3})\\/.*",
       "Luke_Nih_\\1\\2",
       ROIS.BLOCK$name)

ROIS.BLOCK <- ROIS.BLOCK %>%
  right_join(
    PT.XL,
    by = "mriID"
  ) %>%
  filter(
    !is.na(name)
  )

# fMRI classifitation model ####
km_fmri <- ROIS.BLOCK %>%
  select(Max_1,
         Max_2,
         Max_3,
         Max_4) %>%
kmeans(centers = 2)

ROIS.BLOCK$km_fmri_group <- km_fmri$cluster

km_gort <- ROIS.BLOCK %>%
  select(
    gortAccuracy,
    gortRate,
    gortComprehension
  ) %>%
  kmeans(centers = 2)

ROIS.BLOCK$km_gort_group <- km_gort$cluster

km_ctopp <- ROIS.BLOCK %>%
  select(
    ctoppElision,
    ctoppBlendingWords,
    ctoppPhonemeIsolation
  ) %>%
  kmeans(centers = 2)


km_all_cog <- ROIS.BLOCK %>%
  select(
    gortAccuracy,
    gortRate,
    gortComprehension,
    ctoppElision,
    ctoppBlendingWords,
    ctoppPhonemeIsolation
  ) %>%
  kmeans(centers = 2)

# regression
model_1 <- lm(Mean_1 ~ gortFluency + gortComprehension, ROIS.BLOCK)
model_2 <- lm(Mean_2 ~ gortFluency, ROIS.BLOCK)
model_3 <- lm(Mean_3 ~ gortFluency, ROIS.BLOCK)
model_4 <- lm(Mean_4 ~ gortFluency, ROIS.BLOCK)

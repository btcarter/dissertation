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

#Set the working environment.
PT.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                    "data", "participants")

PT.XL <- read.csv(file.path(PT.DIR, "masterdatatrim.csv")) 

PT.LIST <- file.path(PT.DIR, "participants.tsv") # name of output file with participant list in it.

RS.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                    "results", "dissertation")

ROIS.OM.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                 "results", "dissertation", "fMRI", "roiStats", "ns_om_func_mask")

ROIS.READ.DIR <-file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                          "results", "dissertation", "fMRI", "roiStats", "ns_reading_func_mask")

# Load data ####

# roi stats
ROIS.OM.BLOCK <- read.delim2(file.path(ROIS.OM.DIR, "ns_func_block.txt"),
                         header = TRUE,
                         sep = "\t",
                         fill = TRUE,
                         stringsAsFactors = FALSE
                         )

ROIS.OM.PRED <- read.delim2(file.path(ROIS.OM.DIR, "ns_func_predictability.txt"),
                           header = TRUE,
                           sep = "\t",
                           fill = TRUE,
                           stringsAsFactors = FALSE
                          )

ROIS.READ.BLOCK <- read.delim2(file.path(ROIS.READ.DIR, "ns_func_block.txt"),
                               header = TRUE,
                               sep = "\t",
                               fill = TRUE,
                               stringsAsFactors = FALSE
)

ROIS.READ.PRED <- read.delim2(file.path(ROIS.READ.DIR, "ns_func_predictability.txt"),
                              header = TRUE,
                              sep = "\t",
                              fill = TRUE,
                              stringsAsFactors = FALSE
)


# roi mask names were manually created after viewing the mask on the template image
# and with some guidance from the whereami documents
OM.ANAT <- read.delim2(file.path("~","Box","LukeLab","NIH Dyslexia Study",
                                 "data","masks","om_mask_names.txt"),
                       stringsAsFactors = FALSE)

READ.ANAT <- read.delim2(file.path("~","Box","LukeLab","NIH Dyslexia Study",
                                 "data","masks","read_mask_names.txt"),
                         stringsAsFactors = FALSE)


# participant master sheet cleaning ####

PT.XL <- PT.XL %>%
  filter(
    mriID != "Luke_Nih_D029"
  ) %>%
  mutate(
    mriID = as.character(mriID)
  )

# ROI data cleaning ####
# remove blank columns

toss_blanks <- function(x){
  x <- x[,-c(2,3)]
  return(x)
}

remove_header_rows <- function(x, interval){
  row_array <- 2:nrow(x)
  bad_rows <- row_array %% interval
  x <- x[bad_rows != 1,]
  return(x)
}

make_mriID_condition <- function(x){
  x$mriID <-
    gsub("\\/fslhome\\/ben88\\/compute\\/NihReadingStudy\\/functional\\/Luke_Nih_(C|D)(\\d{3})\\/.*",
         "Luke_Nih_\\1\\2",
         x$name)
  
  x$condition <-
    gsub("\\/fslhome\\/ben88\\/compute\\/NihReadingStudy\\/functional\\/Luke_Nih_(C|D)(\\d{3})\\/.*\\/.*\\[(\\w{3,6})_GLT.*",
         "\\3",
         x$name)
  
  return(x)
}

fix_names <- function(DF, COR) {
  COLS <- colnames(DF)
  for (COL in COLS){
    number <- gsub(
      "\\w*_(\\d+)",
      "\\1",
      COL
    )
    value <- gsub(
      "(\\w*_)\\d+",
      "\\1",
      COL
    )
    anat <- as.character(COR$anat_name[COR$mask_num == number])
    new <- paste(value, anat, sep = "")
    COLS[COLS == COL] <- new
  }
  colnames(DF) <- COLS
  return(DF)
}

ROIS.OM.BLOCK <- toss_blanks(ROIS.OM.BLOCK) %>% 
  remove_header_rows(interval = 2) %>%
  make_mriID_condition()

ROIS.OM.BLOCK <- ROIS.OM.BLOCK %>% right_join(
  PT.XL,
  by = "mriID"
)


ROIS.OM.PRED <- toss_blanks(ROIS.OM.PRED) %>% 
  remove_header_rows(interval = 4) %>%
  make_mriID_condition()

ROIS.OM.PRED <- ROIS.OM.PRED %>% right_join(
  PT.XL,
  by = "mriID"
)


ROIS.READ.BLOCK <- toss_blanks(ROIS.READ.BLOCK) %>% 
  remove_header_rows(interval = 2) %>%
  make_mriID_condition()

ROIS.READ.BLOCK <- ROIS.READ.BLOCK %>% right_join(
  PT.XL,
  by = "mriID"
)

ROIS.READ.PRED <- toss_blanks(ROIS.READ.PRED) %>% 
  remove_header_rows(interval = 4) %>%
  make_mriID_condition()

ROIS.READ.PRED <- ROIS.READ.PRED %>% right_join(
  PT.XL,
  by = "mriID"
)

# Regression models ####

omBlockModels <- list()

for (region in 1:12){
  val <- paste("Max_", region, sep = "")
  fmla <- paste(val, " ~ ", "SlowAndWrongCompositeScore", sep = "")
  model <- lm(fmla, ROIS.OM.BLOCK)
  
  if (summary(model)$coefficients[,4][2] <= 0.05) {
    omBlockModels[[val]] <- model
  }
}

omPredModels <- list()

for (region in 1:12){
  val <- paste("Max_", region, sep = "")
  fmla <- paste(val, " ~ ", "SlowAndWrongCompositeScore", sep = "")
  model <- lm(fmla, ROIS.OM.PRED)
  
  if (summary(model)$coefficients[,4][2] <= 0.05) {
    omPredModels[[val]] <- model
  }
}

readBlockModels <- list()

for (region in 1:12){
  val <- paste("Max_", region, sep = "")
  fmla <- paste(val, " ~ ", "SlowAndWrongCompositeScore", sep = "")
  model <- lm(fmla, ROIS.READ.BLOCK)
  
  if (summary(model)$coefficients[,4][2] <= 0.05) {
    readBlockModels[[val]] <- model
  }
}

readPredModels <- list()

for (region in 1:12){
  val <- paste("Max_", region, sep = "")
  fmla <- paste(val, " ~ ", "SlowAndWrongCompositeScore", sep = "")
  model <- lm(fmla, ROIS.READ.PRED)
  
  if (summary(model)$coefficients[,4][2] <= 0.05) {
    readPredModels[[val]] <- model
  }
}

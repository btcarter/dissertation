# Environmental Variables #####
# libraries
library(dplyr)
library(readxl)
library(stringr)
library(reshape2)
library(tidyr)

# options
options(digits = 4)

#Set the working environment.
HM.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                              "data", "eyetracking", "mri_session")
HRF.DIR <- file.path(HM.DIR, "hrfs")
RP.DIR <- file.path(HM.DIR, "reports")

PT.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                    "data", "participants")
PT.XL <- read_excel(file.path("~", "Box", "LukeLab", "NIH Dyslexia Study",
                              "data", "participants", "master.xlsx")) 
PT.LIST1 <- file.path(PT.DIR, "participants.tsv") # name of output file with participant list in it.
PT.LIST2 <- file.path(PT.DIR, "gorted.txt")

RS.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                    "results", "dissertation", "tables")

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
TRIAL.RP <- file.path(RP.DIR, "TrialReport.txt")

# Read in interest areas report.
REPORT1 <- read.delim2(
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


# Make participant lists for MRI analysis ####
PT.XL <- PT.XL %>%
  filter(
    mriEtGood == TRUE,
    structMri == TRUE,
    !is.na(ctoppRapidDigitError)
  )

write.table(PT.XL$mriID,
            file = PT.LIST1, 
            sep = "\t", 
            quote = FALSE,
            col.names = FALSE,
            row.names = FALSE
)

mu <- median(PT.XL$gortFluency)

PT.XL %>%
  select(mriID, gortFluency) %>%
  arrange(desc(gortFluency)) %>%
  mutate(
    group = ifelse (gortFluency > median(PT.XL$gortFluency), "control", "dyslexia")
  ) %>%
  select(
    mriID, group
  ) %>%
  write.table(file = PT.LIST2,
              sep = "\t",
              quote = FALSE,
              col.names = FALSE,
              row.names = FALSE)



# Predictability Data cleaning ####
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

REPORT <- REPORT1 %>%
  select(vars) %>% # only select wanted variables, listed in vars
  filter(
    practice != 1, # remove practice runs
    IA_SKIP == 0,
    TRIAL_START_TIME > 0,
    RECORDING_SESSION_LABEL != "Luke_Nih_D029"
  ) %>%
  mutate(
    "SYNC" = factor_to_numeric(sync_time.1.),
    "IA_FIRST_RUN_DWELL_TIME" = factor_to_numeric(IA_FIRST_RUN_DWELL_TIME),
    "IA_DWELL_TIME" = factor_to_numeric(IA_DWELL_TIME)
    ) %>%
  mutate(
   "START_TIME" = (TRIAL_START_TIME - 
     SYNC + 
     IA_FIRST_RUN_DWELL_TIME)/1000
  ) %>%
  filter(
    IA_DWELL_TIME > 0
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

# Make dataframes ####

df_reading <- df %>% filter(
  Word_Content_Or_Function == "Content", # select fixations on content words only
  stimtype == 1, # select only word interest areas
  IA_SKIP == 0
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
            "START_TIME",
            pred_type,
            "IA_DWELL_TIME")
  
  # transform predictability measure if necessary
  if (pred_type == "LSA_Context_Score") {
    report[[pred_type]] <- scale(report[[pred_type]])
  }
 
  #remove unneeded columns/values and convert times
  report <- report %>%
    arrange(mriID, run, TRIAL_INDEX, START_TIME) %>%
    select(vars) %>%
    mutate(
      IA_FIRST_FIXATION_TIME = START_TIME/1000,
      IA_DWELL_TIME = IA_DWELL_TIME/1000
    ) %>%
    mutate(
      Parametric_times = paste(
        START_TIME,
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
TRIAL <- read.delim(
  TRIAL.RP,
  header = TRUE,
  sep = "\t",
  fill = TRUE,
  stringsAsFactors = FALSE
)

TRIAL$RECORDING_SESSION_LABEL <-
  as.character(TRIAL$RECORDING_SESSION_LABEL)

  # fix bad recording session labels
for (booboo in CORS$RECORDING_SESSION_LABEL) {
  TRIAL$RECORDING_SESSION_LABEL[TRIAL$RECORDING_SESSION_LABEL == booboo] <-
    CORS$CORRECTION[CORS$RECORDING_SESSION_LABEL == booboo]
}

  # add mriID and run number variables
TRIAL$mriID <- toupper(TRIAL$RECORDING_SESSION_LABEL)
TRIAL$mriID <- gsub("R(\\d)(C|D)(\\d{3})",
                     "Luke_Nih_\\2\\3",
                     TRIAL$mriID)
TRIAL$run <- gsub("R(\\d)(C|D)(\\d{3})",
                   "\\1",
                   toupper(TRIAL$RECORDING_SESSION_LABEL))

  # remove all non-study recording session labels
TRIAL <- TRIAL[TRIAL$mriID %in% unique(PT.XL$mriID),]

TRIAL <- TRIAL %>%
  filter(
    sync_time.1. > 0
  ) %>%
  mutate(
    "START_TIME" = START_TIME - sync_time.1.
  )

# Make dataframe #
df_block_read <- TRIAL %>%
  filter(
    practice == 0,
    stimtype == 1
  ) %>%
  select("mriID",
         "INDEX",
         "START_TIME",
         "run"
  )

df_block_pic <- TRIAL %>%
  filter(
    practice == 0,
    stimtype == 2
  ) %>%
  select("mriID",
         "INDEX",
         "START_TIME",
         "run"
  )

# Make Block-HRFs ####

  # make reading blocks
make_blocks <- function(trial_report, output_directory){
    
  #debugging
  # trial_report <- df_block_read
  # output_directory <- file.path(HRF.DIR, "block_read")
    for (a in unique(trial_report$mriID)) {
      
      sub_df <- trial_report %>%
        filter(
          mriID == a
        ) %>%
        arrange(
          run, INDEX
        ) %>%
        mutate(
          START_TIME = START_TIME/1000
          ) %>%
        select(c(2:4))
      
      sub_df$ROW <- 1:nrow(sub_df)
      
      for (r in order(desc(unique(sub_df$run)))) {
        
        if (r > 1){
          r2 <- r-1
          sub_df[sub_df$run == r, ]$ROW =
            sub_df[sub_df$run == r, ]$ROW -
            max(sub_df[sub_df$run == r2, ]$ROW)
        }
      }
      
      sub_df <- sub_df %>%
        select(-"INDEX") %>%
        melt(id = c("run", "ROW")) %>%
        dcast(
          run~ROW
        ) %>%
        select(-1)
      
      write.table(sub_df, 
                  file.path(output_directory, paste(a, ".txt", sep = "")), 
                  sep = "\t", na = "", col.names = FALSE, row.names = FALSE, quote = FALSE)
      
      }
    }

make_blocks(df_block_read, file.path(HRF.DIR, "block_read"))
make_blocks(df_block_pic, file.path(HRF.DIR, "block_pictures"))

# Summary Stats and lmer models of ET data ####

  # load packages
  library(lme4)
  library(lmerTest)

  # add group labels
  df_read_mod <- df_reading %>%
    right_join(
      PT.XL,
      by = "mriID"
    )
  
  df_read_mod$group <- as.factor(df_read_mod$group)
  df_read_mod$mriID <- as.factor(df_read_mod$mriID)

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
      regression_prob = sum(factor_to_numeric(IA_REGRESSION_IN), na.rm = TRUE)/n()
    ) %>%
    ungroup() %>%
    group_by(group) %>%
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
  
  # combine into single table and save it as a tex file in RS.DIR
  sumStats <- rbind(sumStats2,sumStats1) %>%
    knitr::kable(format = "latex")
  cat(sumStats,
      file = file.path(RS.DIR, "om_sum_table.tex"),
      sep = "",
      append = FALSE
      )
  
  # do test
  read_mod_dt <- lmer(
    log(IA_DWELL_TIME) ~ 
      group * scale(log(OrthoMatchModel), scale = FALSE) + (1|mriID),
    df_read_mod
  ) %>%
    summary()
  
  # save results
  knitr::kable(
    read_mod_dt$coefficients,
    format = "latex",
    digits = 3) %>% 
    cat(file = file.path(RS.DIR, "dwell_time_model.tex"),
                         sep = "",
                         append = FALSE)
  
  # do test
  read_mod_ffd <- lmer(
    log(IA_FIRST_FIXATION_DURATION) ~
      group * scale(log(OrthoMatchModel), scale = FALSE) + (1|mriID),
    df_read_mod
  ) %>% 
    summary()
  
  # save results
  knitr::kable(
    read_mod_ffd$coefficients,
    format = "latex",
    digits = 3) %>% 
    cat(file = file.path(RS.DIR,
                         "first_fix_dur_model.tex"),
                         sep = "",
                         append = FALSE)

  # do test
  read_mod_frdt <- lmer(
    log(IA_FIRST_RUN_DWELL_TIME) ~ 
      group * scale(log(OrthoMatchModel), scale = FALSE) + (1|mriID),
    df_read_mod
  ) %>%
    summary()

  # save results
  knitr::kable(
    read_mod_frdt$coefficients,
    format = "latex",
    digits = 3) %>% 
    cat(file = file.path(RS.DIR,
                         "gaze_dur_model.tex"),
        sep = "",
        append = FALSE)
  
# make summary statistics for each group for a t-test ####

  # Predictability Data cleaning ####
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
  
  TTEST <- REPORT1 %>%
    select(vars) %>% # only select wanted variables, listed in vars
    filter(
      practice != 1, # remove practice runs
      TRIAL_START_TIME > 0
    ) %>%
    mutate(
      "SYNC" = factor_to_numeric(sync_time.1.),
      "IA_FIRST_RUN_DWELL_TIME" = factor_to_numeric(IA_FIRST_RUN_DWELL_TIME),
      "IA_DWELL_TIME" = factor_to_numeric(IA_DWELL_TIME)
    ) %>%
    mutate(
      "START_TIME" = (TRIAL_START_TIME - 
                        SYNC + 
                        IA_FIRST_RUN_DWELL_TIME)/1000
    ) %>%
    filter(
      IA_DWELL_TIME > 0
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
  TTEST <- ORTHOS[c("Text_ID",
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
    right_join(TTEST,
               by = c("Text_ID" = "textnumber", 
                      "IA_ID" = "IA_ID")
    )
  
    
TTEST <- TTEST %>%
    group_by(
      Group,
      mriID
    ) %>%
    summarise(
      "MeanFFD" = mean(IA_FIRST_FIXATION_DURATION),
      "MeanDT" = mean(IA_DWELL_TIME),
      "MeanGD" = mean(IA_FIRST_RUN_DWELL_TIME),
      skipping_prob = sum(IA_SKIP)/n(),
      refixation_prob = sum(IA_FIXATION_COUNT >= 2)/n(),
      regression_prob = sum(factor_to_numeric(IA_REGRESSION_IN), na.rm = TRUE)/n()
    ) %>%
    ungroup() %>%
    filter(
      mriID != "Luke_Nih_D029"
    )
  
  # statistical tests ####
  e_var <- c("MeanFFD", "MeanDT", "MeanGD", "skipping_prob",
             "refixation_prob", "regression_prob")
  
  tab_t <- data.frame()
  
  for (i in e_var){
    model <- t.test(TTEST[[i]] ~ TTEST[["Group"]], data=TTEST)
    tab_var <- data.frame(
      "Variable" = i,
      "T-statistic" = as.numeric(model$statistic),
      "Degrees of Freedom" = as.numeric(model$parameter),
      "p-value" = model$p.value
    )
    tab_t <- rbind(tab_t, tab_var)
  }
  
    tab_t %>%
    knitr::kable(format = "latex") %>%
    cat(file = file.path(RS.DIR, "omTtest.tex"),
        sep = "",
        append = FALSE)
  
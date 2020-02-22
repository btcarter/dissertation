###################################
# TABLE 1
# =======
#
# Author: Benjamin Carter
# Date: 2020-02-20
# Purpose: This script will use data from master.xlsx and create a demographics table for my dissertation, with an xtable being the final output
###################################

# load packages
list.of.packages <- c("readxl", "dplyr", "tidyr", "tableone")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]                           # compare the list to the installed packages list and add missing packages to new list
if(length(new.packages)) install.packages(new.packages, dependencies = TRUE)                                          # install missing packages
lapply(list.of.packages,library,character.only = TRUE)                                                                # load packages

# I/O variables
OUT.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data", "results", "dissertation")


# load data
WB <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data", "participants", "master.xlsx")
df <- read_excel(WB)

# select data for fMRI only

VARS <- c("group", "wasiVocab", "wasiMatrix",
          "gortRate", "gortAccuracy", "gortFluency", "gortComprehension",
          "ctoppElision", "ctoppBlendingWords", "ctoppPhonemeIsolation",
          "ctoppRapidDigitTime", "ctoppRapidDigitError",
          "ctoppRapidLetterTime", "ctoppRapidLetterError",
          "Are you a student at BYU or UVU?",
          "Can you provide documentation of this diagnosis?",
          "Have you ever been diagnosed with other learning disorders?",
          "Have you ever been diagnosed with depression, anxiety, a learning disability, ADD/ADHD, or any other neurologic or psychiatric disorder?",
          "Are you male or female?",
          "What is your age?",
          "How would you describe your ethnicity?",
          "How would you describe your race?"
          )

df <- df %>%
  filter(mriEtGood == TRUE,
         structMri == TRUE,
         !is.na(wasiVocab)) %>%
  select(VARS)

# format and rename variables
LABS <- c("Group", "Vocabulary Score", "Matrix Reasoning",
          "Reading Rate", "Reading Accuracy", "Reading Fluency", "Comprehension",
          "Elision", "Blending Words", "Phoneme Isolation",
          "Rapid Digit Naming Time", "Rapid Digit Naming Error",
          "Rapid Letter Naming Time", "Rapid Letter Naming Error",
          "University student",
          "Documentation",
          "Other learning disorders",
          "Other psychiatric disorders",
          "Gender",
          "Age",
          "Ethnicity",
          "Race")

names(df) <- LABS

FACTORS <- c("Group", "University student", "Other psychiatric disorders", "Other psychiatric disorders", "Gender", "Ethnicity", "Race")

for (i in FACTORS) {
  df[[i]] <- as.factor(df[[i]])
}

# create table 1
CONTVARS <- c("Vocabulary Score", "Matrix Reasoning",
          "Reading Rate", "Reading Accuracy", "Reading Fluency", "Comprehension",
          "Elision", "Blending Words", "Phoneme Isolation",
          "Rapid Digit Naming Time", "Rapid Digit Naming Error",
          "Rapid Letter Naming Time", "Rapid Letter Naming Error",
          "Age")

LABS2 <- c("Vocabulary Score", "Matrix Reasoning",
           "Reading Rate", "Reading Accuracy", "Reading Fluency", "Comprehension",
           "Elision", "Blending Words", "Phoneme Isolation",
           "Rapid Digit Naming Time", "Rapid Digit Naming Error",
           "Rapid Letter Naming Time", "Rapid Letter Naming Error",
           "University student",
           "Documentation",
           "Other learning disorders",
           "Other psychiatric disorders",
           "Gender",
           "Age",
           "Ethnicity",
           "Race")

tab <- CreateTableOne(LABS2, "Group", df, test = FALSE)
tab_tex <- print(tab,
                 printToggle = FALSE,
                 noSpaces = TRUE,
                 showAllLevels = TRUE)

# kable it, maybe try xtable
table1 <- knitr::kable(tab_tex, format = "latex")

# save the output
cat(table1,
    file = file.path(OUT.DIR, "table1.tex"),
    sep = "",
    append = FALSE)

#####
# do 
#####



###################################
# TABLE 1
# =======
#
# Author: Benjamin Carter
# Date: 2020-02-20
# Purpose: This script will use data from master.xlsx and create a demographics table for my dissertation, with an xtable being the final output
###################################

# load packages
list.of.packages <- c("readxl", "dplyr", "tidyr", "tableone", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]                           # compare the list to the installed packages list and add missing packages to new list
if(length(new.packages)) install.packages(new.packages, dependencies = TRUE)                                          # install missing packages
lapply(list.of.packages,library,character.only = TRUE)                                                                # load packages

# I/O variables
# OUT.DIR <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data", "results", "dissertation")
OUT.DIR <- file.path("C:", "Users", "CarteB", "Box", "LukeLab", "NIH Dyslexia Study", "data", "results", "dissertation")
TAB.DIR <- file.path(OUT.DIR, "tables")
FIG.DIR <- file.path(OUT.DIR, "figures")


# load data
# WB <- file.path("~", "Box", "LukeLab", "NIH Dyslexia Study", "data", "participants", "masterdatatrim.xlsx")
WB <- file.path("C:", "Users", "CarteB", "Box", "LukeLab", "NIH Dyslexia Study", "data", "participants", "masterdatatrim.xlsx")
df.big <- read_xlsx(WB)

# select data for fMRI only

VARS <- c("group", 
          "wasiFSIQ2",
          "gortSumofScaledScores",
          "ctoppCompositePA", "ctoppCompositeRSN",
          "Are you a student at BYU or UVU?",
          "Can you provide documentation of this diagnosis?",
          "Have you ever been diagnosed with other learning disorders?",
          "Have you ever been diagnosed with depression, anxiety, a learning disability, ADD/ADHD, or any other neurologic or psychiatric disorder?",
          "Are you male or female?",
          "What is your age?",
          "How would you describe your ethnicity?",
          "How would you describe your race?"
          )

df <- df.big %>%
  filter(mriEtGood == TRUE,
         structMri == TRUE,
         !is.na(ctoppRapidLetterTime),
         mriID != "Luke_Nih_D029"
         ) %>%
  select(VARS)

# format and rename variables
LABS <- c("Group", 
          "FSIQ-2",
          "GORT-V Sum of Scaled Scores",
          "CTOPP Phonological Awareness",
          "CTOPP Rapid Symbolic Naming",
          "University student",
          "Documentation",
          "Other learning disorders",
          "Other psychiatric disorders",
          "Gender",
          "Age",
          "Ethnicity",
          "Race")

names(df) <- LABS

FACTORS <- c("Group", 
             "University student", 
             "Other psychiatric disorders", 
             "Other psychiatric disorders", 
             "Gender", "Ethnicity", "Race")

for (i in FACTORS) {
  df[[i]] <- as.factor(df[[i]])
}

levels(df$Group) <- c("Control", "Dyslexia")

# create table 1 ####
LABS2 <- c("Gender",
           "Age",
           "Ethnicity",
           "Race",
           "University student",
           "Documentation",
           "Other learning disorders",
           "Other psychiatric disorders"
           )

tab <- CreateTableOne(LABS2, "Group", df, test = FALSE)
tab_tex <- print(tab,
                 printToggle = FALSE,
                 noSpaces = TRUE,
                 showAllLevels = TRUE)

# kable it, maybe try xtable
table1 <- knitr::kable(tab_tex, format = "latex")

# save the output
cat(table1,
    file = file.path(TAB.DIR, "table1.tex"),
    sep = "",
    append = FALSE)

# make table 2 ####

mean_sd <- function(a) {
  b <- round(mean(a, na.rm = TRUE), digits = 2)
  c <- round(sd(a, na.rm = TRUE), digits = 2)
  return(paste(b," (",c,")",sep=""))
}

CONTVARS <- c("Group", 
              "FSIQ-2",
              "GORT-V Sum of Scaled Scores",
              "CTOPP Phonological Awareness",
              "CTOPP Rapid Symbolic Naming"
              )


cog_tab <- df[,CONTVARS] %>%
  group_by(Group) %>%
  summarise(
    `FSIQ-2` = mean_sd(`FSIQ-2`),
    `GORT-V Sum of Scaled Scores` = mean_sd(`GORT-V Sum of Scaled Scores`),
    `CTOPP Phonological Awareness` = mean_sd(`CTOPP Phonological Awareness`),
    `CTOPP Rapid Symbolic Naming` = mean_sd(`CTOPP Rapid Symbolic Naming`)
  ) %>%
  gather(Test, Value, "FSIQ-2":"CTOPP Rapid Symbolic Naming") %>%
  spread(Group, Value) %>%
  knitr::kable(format = "latex")

# save the output
cat(cog_tab,
    file = file.path(TAB.DIR, "cog_tab.tex"),
    sep = "",
    append = FALSE)





# statistical tests ####
e_var <- c("FSIQ-2",
           "GORT-V Sum of Scaled Scores",
           "CTOPP Phonological Awareness",
           "CTOPP Rapid Symbolic Naming")
tab_t <- data.frame()

for (i in e_var){
  model <- t.test(df[[i]] ~ df[["Group"]], data=df)
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
  cat(file = file.path(TAB.DIR, "tTests.tex"),
    sep = "",
    append = FALSE)

# facet wrap some graphs

sort_vars <- tab_t$Variable


for (i in sort_vars) {
# i <- "Vocabulary Score"
  d <- paste(i,".pdf", sep="")
  NAME <- file.path(FIG.DIR, d)
  pdf(NAME)
  
  PLOT <- df %>%
  select(Group, i) %>%
  ggplot(aes(Group, df[[i]])) +
  geom_boxplot(aes(y = df[[i]])) +
    geom_jitter(alpha = 0.65) +
    labs(title = i,
         y="Score") +
    theme_classic()
  print(PLOT)
  dev.off()
}


library(compareGroups)
df.tab <- df.big %>%
  select(
    group,
    wasiVocab,
    wasiMatrix
  )
compareGroups(group ~ wasiVocab + wasiMatrix, df.tab) %>% createTable()


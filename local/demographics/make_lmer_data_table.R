# This script will assemble a data table for use in 3dLMEr

library(readxl)
library(dplyr)

PART_LIST <- file.path("C:", "Users", "CarteB", "Box", "LukeLab", "NIH Dyslexia Study", "data",
"participants", "master.xlsx")

df <- read_xlsx(PART_LIST) %>% 
  select(
    mriID,
    group
  )

exclude <- c("Luke_Nih_D029", "Luke_Nih_D028", "Luke_Nih_D024", 
             "Luke_Nih_D005", "Luke_Nih_D004", "Luke_Nih_D002",
             "Luke_Nih_D015")

df <- df %>% 
  filter(
    !(mriID %in% exclude)
  )


# expand table with participant file names
# df <- df %>% rbind(df)
# df$condition <- c(
#   rep("ortho", 52)
# )

df.expanded <- df %>% 
  mutate(
    run = 1
  )

for (a in seq(2,6)){
  df.expanded <- df %>% 
    mutate(
      run = a
    ) %>% 
    rbind(df.expanded)
}

df.expanded <- df.expanded %>% 
  arrange(
    run
  ) %>% 
  mutate(
    InputFile = paste(
      "${FUNC_DIR}/",
      mriID,
      "/predictability/predictability_",
      run,
      "_blur5_ANTS_resampled+tlrc'[3]'",
      " ",
      " \\",
      sep = ""
    )
  )

  
  
OUT <- file.path("C:", "Users", "CarteB", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                 "participants", "lmerTable.txt")

write.table(df.expanded, file = OUT, sep = "  ", row.names = FALSE, quote = FALSE)

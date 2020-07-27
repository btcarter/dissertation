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


# expand table with participant file names
df <- df %>% rbind(df)
df$condition <- c(
  rep("reading", 52),
  rep("pictures", 52)
)

df <- df %>% 
  mutate(
    InputFile = if_else(
      condition == "reading",
      paste(
        "${FUNC_DIR}/",
        mriID,
        "/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'",
        " ",
        " \\",
        sep = ""
      ),
      paste(
        "${FUNC_DIR}/",
        mriID,
        "/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'",
        " ",
        " \\",
        sep = ""
      )
    )
  ) %>% 
  rename(
    Subj = mriID
  ) %>% 
  arrange(
    group,
    Subj,
    condition
  )

OUT <- file.path("C:", "Users", "CarteB", "Box", "LukeLab", "NIH Dyslexia Study", "data",
                 "participants", "lmerTable.tsv")

write.table(df, file = OUT, sep = "\t", row.names = FALSE)

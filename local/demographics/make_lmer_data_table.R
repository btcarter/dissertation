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
df <- df %>% rbind(df) %>% rbind(df) %>% rbind(df)
df$condition <- c(
  rep("pos", 52),
  rep("lsa", 52),
  rep("ortho",52),
  rep("pictures", 52)
)

df <- df %>% 
  mutate(
    InputFile = if_else(
      condition == "pos",
      paste(
        "${FUNC_DIR}/",
        mriID,
        "/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'",
        " ",
        " \\",
        sep = ""
      ),
      if_else(
        condition == "lsa",
        paste(
          "${FUNC_DIR}/",
          mriID,
          "/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'",
          " ",
          " \\",
          sep = ""
        ),
        if_else(
          condition == "ortho",
          paste(
            "${FUNC_DIR}/",
            mriID,
            "/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'",
            " ",
            " \\",
            sep = ""
          ),
          paste(
            "${FUNC_DIR}/",
            mriID,
            "/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'",
            " ",
            " \\",
            sep = ""
          )
        )
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

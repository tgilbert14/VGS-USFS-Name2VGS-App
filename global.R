## -----------------------------------------------------------------
## Timothy Gilbert
## Last update: 2024-06-13
## Reads a shape file from USDA.gov from 5/17/2022 to see Allotment/Pasture data
## -----------------------------------------------------------------

#Global
library(shiny)
library(shinydashboardPlus)
library(tidyverse)
library(DT)
library(shinycssloaders)
library(shinythemes)
library(shinyjs)

# shape file into for USFS
usfs_attributes<- read_csv("USFS_shapefileInfo.csv")

## below is original code on how file was created using usfs shapefile pasture
## and ranger district enterprise files

# ## csv of Allotment/Pasture shape file data
# usfs_attributes<- read_csv("data/Export.csv")
# ## column for region number to sort by
# usfs_attributes$Region<- substr(usfs_attributes$MANAGING_O,1,2)
# usfs_attributes$ADMIN_ORG_<- str_to_title(usfs_attributes$ADMIN_ORG_)
# usfs_attributes$MANAGING_1<- str_to_title(usfs_attributes$MANAGING_1)
# usfs_attributes$ALLOTMENT_<- str_to_title(usfs_attributes$ALLOTMENT_)
# usfs_attributes$PASTURE_NA<- str_to_title(usfs_attributes$PASTURE_NA)
# 
# ## ordering by region and alphabet
# usfs_attributes<- usfs_attributes[
#   with(usfs_attributes, order(Region, ADMIN_ORG_)),
# ]
# ## getting forest info as well
# usfs_forest<- read_csv("data/Export_forest.csv")
# names(usfs_forest)[7] <- "ADMIN_ORG_"
# 
# usfs_forest_trim <- usfs_forest %>% 
#   select(ADMIN_ORG_, FORESTNAME)
# 
# usfs_attributes<- left_join(usfs_attributes, usfs_forest_trim, relationship = "many-to-many")
# 
# usfs_attributes <- usfs_attributes %>% 
#   filter(!is.na(Region)) %>% 
#   filter(!is.na(ADMIN_ORG_)) %>% 
#   filter(!is.na(MANAGING_1)) %>% 
#   filter(!is.na(ALLOTMENT_)) %>% 
#   filter(!is.na(PASTURE_NA))
# usfs_attributes<- usfs_attributes %>% 
#     filter(Region != "NA") %>%
#     filter(ADMIN_ORG_Region != "NA") %>%
#     filter(MANAGING_1Region != "NA") %>%
#     filter(ALLOTMENT_Region != "NA") %>%
#     filter(PASTURE_NARegion != "NA")
# write_csv(usfs_attributes, "USFS_shapefileInfo.csv")
# View(usfs_attributes)

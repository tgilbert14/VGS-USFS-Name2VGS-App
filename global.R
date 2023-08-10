## -----------------------------------------------------------------
## Timothy Gilbert
## 2022-05-17
## Reads a shape file from USDA.gov from 5/17/2022 to see Allotment/Pasture data
## -----------------------------------------------------------------

#Global
library(shiny)
library(shinydashboardPlus)
library(tidyverse)
library(DT)
library(shinycssloaders)
library(shinythemes)
## csv of Allotment/Pasture shape file data
usfs_attributes<- read_csv("data/Export.csv")
## column for region number to sort by
usfs_attributes$Region <- substr(usfs_attributes$MANAGING_O,1,2)
## ordering by region and alphabet
usfs_attributes<- usfs_attributes[
  with(usfs_attributes, order(Region, ADMIN_ORG_)),
]

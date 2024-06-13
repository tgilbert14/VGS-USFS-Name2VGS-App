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
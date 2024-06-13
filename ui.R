## ------------------------------------------------------------------------------
## Timothy Gilbert
## 2022-05-17
## Reads a shape file from USDA.gov from 5/17/2022 to see Allotment/Pasture data
## ------------------------------------------------------------------------------

## Define UI
shinyUI(fluidPage(
  theme = shinytheme("paper"),collapsable = TRUE,

    # Application title
    titlePanel("USFS Naming Convention"),#theme = "bootstrap_yeti.css",
    # Sidebar with a slider input for number of bins
    sidebarLayout(fluid = T,
        sidebarPanel(
            
            selectInput("selectR", "Select Region #:", choices = c("",unique(usfs_attributes$Region)), selected = F, selectize=TRUE, multiple = F),
            submitButton("Load Regions"),
            br(),
            selectizeInput("selectForest", "Select Region to generate forests", choices = NULL ,selected = F, multiple = F),
            submitButton("Load Ranger Districts"),
            br(),
            selectInput("selectRD", "Select Forest to generate Ranger Districts", choices = NULL ,selected = F, multiple = T),
            submitButton("Get Allotments"),
            br(),
            selectInput("selectSite", label= "Select Ranger District to generate Allotments", choices = NULL ,selected = F, multiple = T),
            submitButton("Get Pastures")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            
        shinydashboardPlus::box(
            title = 'Selected Ranger District Pasture Data:', width = 12,
            footer = 'Naming Convention: MANAGING # - ALLOTMENT # - PASTURE # - SITE
            [https://data.fs.usda.gov/geodata/edw/datasets.php -updated 5/17/2022]',
            
            tableOutput("nameTable")),
            
            title = 'USFS Pasture Location',solidHeader = T,
            #selectInput('p', 'items per page', choices = c(10,20,30,40,50)),
            withSpinner(DT::dataTableOutput("distTable"),type = 6))
        ),
    )
)
## ------------------------------------------------------------------------------
## Timothy Gilbert
## Last update: 2024-06-13
## ------------------------------------------------------------------------------

## Define UI
shinyUI(fluidPage(
  theme = shinytheme("paper"),collapsable = TRUE,
  useShinyjs(),

    # Application title
    titlePanel("USFS Naming Convention"),#theme = "bootstrap_yeti.css",
    # Sidebar with a slider input for number of bins
    sidebarLayout(fluid = T,
        sidebarPanel(
            div(id="div1",
             selectInput("selectR", "Select Region #:", choices = c("",unique(usfs_attributes$Region)), selected = F, selectize=TRUE, multiple = F),
             submitButton("Load Regions")),
            br(),
            div(id="div2",
             selectizeInput("selectForest", "Select Region to generate forests", choices = NULL ,selected = F, multiple = F),
             submitButton("Load Ranger Districts")),
            br(),
            div(id="div3",
             selectInput("selectRD", "Select Forest to generate Ranger Districts", choices = NULL ,selected = F, multiple = T),
             submitButton("Get Allotments")),
            br(),
            div(id="div4",
             selectInput("selectSite", label= "Select Ranger District to generate Allotments", choices = NULL ,selected = F, multiple = T),
             submitButton("Get Pastures"))
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
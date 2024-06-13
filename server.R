## -----------------------------------------------------------------
## Timothy Gilbert
## Last update: 2024-06-13
## ----------------------------------------------------------------
## Server
shinyServer(function(input, output, session) {
  
    ## hide initial selection options until needed
    shinyjs::hide("div2")
    shinyjs::hide("div3")
    shinyjs::hide("div4")
  
    ## initial state so loading bar does not spin on start
    output$distTable<- NULL
    
    forest <- reactive({
      ## filtering to forests by region selection - SelectR
      req(input$selectR)
      
      shinyjs::hide("div1")
      shinyjs::show("div2")
      
      usfs_attributes <- usfs_attributes %>%
        arrange(FORESTNAME)
      a1 <- unique(usfs_attributes$FORESTNAME[usfs_attributes$Region == input$selectR]) # nolint
      a1 <- a1[!is.na(a1)]
      return(a1)
    })

    region <- reactive({
      ## filtering to ranger district by forest selection - SelectForest
      req(input$selectForest)
      
      shinyjs::hide("div2")
      shinyjs::show("div3")

      usfs_attributes <- usfs_attributes %>%
        arrange(MANAGING_1)
      a2 <- unique(usfs_attributes$MANAGING_1[usfs_attributes$FORESTNAME == input$selectForest]) # nolint
      a2 <- a2[!is.na(a2)]
      return(a2)
    })
    
    sites <- reactive({
      ## filtering to allotments by ranger district selection - SelectRD
      req(input$selectRD)
      
      shinyjs::hide("div3")
      shinyjs::show("div4")
      
      usfs_attributes <- usfs_attributes %>%
        arrange(ALLOTMENT_)
      a3 <- unique(usfs_attributes$ALLOTMENT_[usfs_attributes$MANAGING_1 == input$selectRD]) # nolint
      a3 <- a3[!is.na(a3)]
      return(a3)
    })
    
    ## updating reactive selections above - need to be seperate
    observe({
      updateSelectizeInput(session, "selectForest",
                           label = "Select A Forest",
                           choices = c("", forest()), selected = F#, server = TRUE
      )
    })
    observe({
      updateSelectInput(session, "selectRD",
                        label = "Select A Ranger District",
                        choices = c("", region()), selected = F#, server = TRUE
      )
    })
    observe({
      updateSelectInput(session, "selectSite",
                        label = "Select Allotment(s) if needed",
                        choices = c("", sites()), selected = F#, server = TRUE
      )
    })
    
    ## reactive data based on selections
    react_data <- reactive({
        district <- input$selectRD
        req(district)

        usfs_ranger_district <- usfs_attributes %>% # nolint
            filter(Region %in% c(input$selectR)) %>%
            filter(MANAGING_1 %in% c(district))

        usfs_ranger_district <- usfs_ranger_district[
            with(usfs_ranger_district, order(
                PASTURE_NA,
                MANAGING_O, ALLOTMENT1, PASTURE_NU, ALLOTMENT_, FORESTNAME
            )),
        ]
    })

    ## generating table for allotment selection and cleaning up
    observeEvent(input$selectRD, {
        output$distTable <- DT::renderDT({
            usfs_ranger_district <- react_data()

            usfs_ranger_district <- usfs_ranger_district %>%
                filter(Region %in% c(input$selectR)) %>%
                filter(MANAGING_1 %in% c(input$selectRD)) %>%
                mutate(MANAGING_O = paste0(
                    substr(MANAGING_O, 1, 2), "-",
                    substr(MANAGING_O, 3, 4), "-",
                    substr(MANAGING_O, 5, 6), "-"
                )) %>%
                #mutate(PASTURE_NA = paste0(PASTURE_NA, " PASTURE")) %>%
                #mutate(ALLOTMENT1 = paste0(ALLOTMENT1, "-")) %>%
                select(PASTURE_NA, MANAGING_O, ALLOTMENT1, PASTURE_NU,
                MANAGING_1, PASTURE_ST, FORESTNAME, ALLOTMENT_)
            
            ## concat VGS-USFS name
            usfs_ranger_district <- usfs_ranger_district %>%
              mutate("VgsName" = paste0(MANAGING_O,"-",ALLOTMENT1,"-",PASTURE_NU))
            
            names(usfs_ranger_district)[1] <- "Pasture"
            names(usfs_ranger_district)[2] <- "Managing#"
            names(usfs_ranger_district)[3] <- "Allotment#"
            names(usfs_ranger_district)[4] <- "Pasture#"
            names(usfs_ranger_district)[5] <- "RangerDistrict"
            names(usfs_ranger_district)[6] <- "Status"
            names(usfs_ranger_district)[7] <- "Forest"
            names(usfs_ranger_district)[8] <- "Allotment"
            
            ## re-order table
            usfs_ranger_district <- usfs_ranger_district %>%
              select("VgsName","Pasture","Allotment","RangerDistrict","Forest",
                     "Managing#","Allotment#","Pasture#","Status")

            usfs_ranger_district <- as.data.frame(usfs_ranger_district)

            datafile <- DT::datatable(usfs_ranger_district, extensions = 'Buttons',
                options = list(pageLength = 100,
                               dom = 'Bfrtip',
                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print')),
                style = "bootstrap",
                class = "compact cell-border hover display",
                filter = list(position = "top", plain = TRUE)
            )
        })
    })

    ## generating table for pasture selection and cleaning up
    observeEvent(input$selectSite, {
        output$distTable <- DT::renderDT({
            site <- input$selectSite
            req(site)

            usfs_ranger_district <- react_data()

            usfs_ranger_district <- usfs_attributes %>%
                filter(Region %in% c(input$selectR)) %>%
                filter(MANAGING_1 %in% c(input$selectRD)) %>%
                filter(ALLOTMENT_ == c(site))

            usfs_ranger_district <- usfs_ranger_district %>%
                mutate(MANAGING_O = paste0(
                    substr(MANAGING_O, 1, 2), "-",
                    substr(MANAGING_O, 3, 4), "-",
                    substr(MANAGING_O, 5, 6), "-"
                )) %>%
                #mutate(PASTURE_NA = paste0(PASTURE_NA, " PASTURE")) %>%
                #mutate(ALLOTMENT1 = paste0(ALLOTMENT1, "-")) %>%
               select(PASTURE_NA, MANAGING_O, ALLOTMENT1, PASTURE_NU,
                     MANAGING_1, PASTURE_ST, FORESTNAME, ALLOTMENT_)

            ## concat VGS-USFS name
            usfs_ranger_district <- usfs_ranger_district %>%
              mutate("VgsName" = paste0(MANAGING_O,"-",ALLOTMENT1,"-",PASTURE_NU))
            
            names(usfs_ranger_district)[1] <- "Pasture"
            names(usfs_ranger_district)[2] <- "Managing#"
            names(usfs_ranger_district)[3] <- "Allotment#"
            names(usfs_ranger_district)[4] <- "Pasture#"
            names(usfs_ranger_district)[5] <- "RangerDistrict"
            names(usfs_ranger_district)[6] <- "Status"
            names(usfs_ranger_district)[7] <- "Forest"
            names(usfs_ranger_district)[8] <- "Allotment"
            
            ## re-order table
            usfs_ranger_district <- usfs_ranger_district %>%
              select("VgsName","Pasture","Allotment","RangerDistrict","Forest",
                     "Managing#","Allotment#","Pasture#","Status")

            usfs_ranger_district <- as.data.frame(usfs_ranger_district)

            datafile <- datatable(usfs_ranger_district,extensions = 'Buttons',
                                  options = list(pageLength = 100,
                                                 dom = 'Bfrtip',
                                                 buttons = c('copy', 'csv', 'excel', 'pdf', 'print')),
                                  style = "bootstrap",
                                  class = "compact cell-border hover display",
                                  filter = list(position = "top", plain = TRUE)
            )
        })
    })
})

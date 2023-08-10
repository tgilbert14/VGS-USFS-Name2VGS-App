## -----------------------------------------------------------------
## Timothy Gilbert
## 2022-05-17
## Reads a shape file from USDA.gov from 5/17/2022 to see Allotment/Pasture data
## ----------------------------------------------------------------
## Server
shinyServer(function(input, output, session) {

    ## filtering selection by region selection
    region <- reactive({
        req(input$selectR)
        ## organizing
        usfs_attributes <- usfs_attributes %>%
            arrange(MANAGING_1)
        a1 <- usfs_attributes$MANAGING_1[usfs_attributes$Region == input$selectR] # nolint
        return(a1)
    })


    ## filtering selection by Ranger District Selected
    sites <- reactive({
        req(input$selectID)
        ## organizing
        usfs_attributes <- usfs_attributes %>%
            arrange(ALLOTMENT_)
        a <- usfs_attributes$ALLOTMENT_[usfs_attributes$MANAGING_1 == input$selectID] # nolint
        return(a)
    })

    observe({
        # create selection box
        updateSelectizeInput(session, "selectID",
            label = "Type in Ranger District:",
            choices = c("", region()), selected = F, server = TRUE
        )
    })

    observe({
        # create selection box
        updateSelectizeInput(session, "selectSite",
            label = "Select Allotment:",
            choices = c("", sites()), selected = F, server = TRUE
        )
    })

    react_data <- reactive({
        district <- input$selectID

        req(district)

        usfs_ranger_district <- usfs_attributes %>% # nolint
            filter(Region %in% c(input$selectR)) %>%
            filter(MANAGING_1 %in% c(district))

        usfs_ranger_district <- usfs_ranger_district[
            with(usfs_ranger_district, order(
                PASTURE_NA,
                MANAGING_O, ALLOTMENT1, PASTURE_NU
            )),
        ]
    })

    ## table for allotment selection
    observeEvent(input$selectID, {
        output$distTable <- DT::renderDT({
            usfs_ranger_district <- react_data()

            usfs_ranger_district <- usfs_ranger_district %>%
                filter(Region %in% c(input$selectR)) %>%
                filter(MANAGING_1 %in% c(input$selectID)) %>%
                mutate(MANAGING_O = paste0(
                    substr(MANAGING_O, 1, 2), "-",
                    substr(MANAGING_O, 3, 4), "-",
                    substr(MANAGING_O, 5, 6), "-"
                )) %>%
                mutate(PASTURE_NA = paste0(PASTURE_NA, " PASTURE")) %>%
                mutate(ALLOTMENT1 = paste0(ALLOTMENT1, "-")) %>%
                select(PASTURE_NA, MANAGING_O, ALLOTMENT1, PASTURE_NU,
                MANAGING_1, PASTURE_ST)

            names(usfs_ranger_district)[1] <- "PASTURE FOLDER NAME"
            names(usfs_ranger_district)[2] <- "MANAGING #"
            names(usfs_ranger_district)[3] <- "ALLOTMENT #"
            names(usfs_ranger_district)[4] <- "PASTURE #"
            names(usfs_ranger_district)[5] <- "RANGER DISTRICT"
            names(usfs_ranger_district)[6] <- "PASTURE STATUS"

            usfs_ranger_district <- as.data.frame(usfs_ranger_district)

            datafile <- datatable(usfs_ranger_district,
                options = list(pageLength = 20),
                style = "bootstrap",
                class = "compact cell-border hover display",
                filter = list(position = "top", plain = TRUE)
            )
        })
    })

    ## table for pasture selection
    observeEvent(input$selectSite, {
        output$distTable <- DT::renderDT({
            site <- input$selectSite
            req(site)

            usfs_ranger_district <- react_data()

            usfs_ranger_district <- usfs_attributes %>%
                filter(Region %in% c(input$selectR)) %>%
                filter(MANAGING_1 %in% c(input$selectID)) %>%
                filter(ALLOTMENT_ == c(site))

            usfs_ranger_district <- usfs_ranger_district %>%
                mutate(MANAGING_O = paste0(
                    substr(MANAGING_O, 1, 2), "-",
                    substr(MANAGING_O, 3, 4), "-",
                    substr(MANAGING_O, 5, 6), "-"
                )) %>%
                mutate(PASTURE_NA = paste0(PASTURE_NA, " PASTURE")) %>%
                mutate(ALLOTMENT1 = paste0(ALLOTMENT1, "-")) %>%
                select(PASTURE_NA, MANAGING_O, ALLOTMENT1, PASTURE_NU,
                MANAGING_1, PASTURE_ST)

            names(usfs_ranger_district)[1] <- "PASTURE FOLDER NAME"
            names(usfs_ranger_district)[2] <- "MANAGING #"
            names(usfs_ranger_district)[3] <- "ALLOTMENT #"
            names(usfs_ranger_district)[4] <- "PASTURE #"
            names(usfs_ranger_district)[5] <- "RANGER DISTRICT"
            names(usfs_ranger_district)[6] <- "PASTURE STATUS"

            usfs_ranger_district <- as.data.frame(usfs_ranger_district)

            datafile <- datatable(usfs_ranger_district,
                style = "bootstrap",
                class = "compact cell-border hover display",
                filter = list(position = "top", plain = TRUE)
            )
        })
    })
})

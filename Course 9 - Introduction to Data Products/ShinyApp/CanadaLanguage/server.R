library(leaflet)
library(DT)
library(ggplot2)
#library(RColorBrewer)
#library(scales)
#library(lattice)
#library(dplyr)

function(input, output, session) {
    
    ## Interactive Map ###########################################
    
    # Create the map
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(lng = -80, lat = 50, zoom = 5)
    })
    
    output$pieNational <- renderPlot({
        ageBy <- input$age
        provinceBy <- input$province
        
        subdata <- data[data$Age==ageBy & data$Province==provinceBy,
                        c("Province","Division",
                          "Age","ENG","FRA","ENGFRA","NO"), 
                        with=FALSE]
        subdata <- data.frame(
            Language=c("English","French","Both languages","Neither language"),
            Value=c(sum(subdata$ENG), sum(subdata$FRA), sum(subdata$ENGFRA), sum(subdata$NO)) )
        ggplot(data=subdata, aes(x=factor(1), y=Value, fill=Language) ) +
            geom_bar(width=1, stat="identity") +
            coord_polar(theta="y") +
            ylab("") + xlab("") + labs(fill="") +
            theme(axis.ticks = element_blank(), panel.grid  = element_blank(),
                  axis.text = element_blank(), legend.position = "right") +
            ggtitle(paste0("Statistics of ",provinceBy))
    })
    
    # This observer is responsible for maintaining the circles and legend,
    # according to the variables the user has chosen to map to color and size.
    observe({
        languageBy <- input$language
        ageBy <- input$age
        
        subdata <- data[data$Age==ageBy & data$Province!="Canada",
                        c("Province","Division","Age",languageBy,
                          paste0(languageBy,"Percent"),paste0(languageBy,"ChangePercent"),
                          "latitude","longitude"), 
                        with=FALSE]
        setnames(subdata,c("Province","Division","Age","LAN","LANPercent","LANChangePercent","latitude","longitude"))
        
        radius <- sqrt(subdata$LAN) * 60
        colorData <- subdata$LANPercent
        pal <- colorBin("Blues", colorData, pretty = TRUE)
        
        leafletProxy("map", data = subdata) %>%
            clearShapes() %>%
            addCircles(~longitude, ~latitude, radius=radius,
                       stroke=FALSE, fillOpacity=0.6, fillColor=pal(colorData)) %>% 
            addLegend("bottomright", pal=pal, values=colorData,
                      title="% among the total population of the cities/divisions", layerId="colorLegend")
    })
    
    ## Data Explorer ###########################################
    
    output$datatable <- DT::renderDataTable({
        provinceBy <- input$province1
        ageBy <- input$age1
        if(provinceBy=="Canada"){
            df <- data[data$Age==ageBy,
                       -c("Geocode","CACode","Age","latitude","longitude"),
                       with=FALSE]
        } else {
            df <- data[data$Age==ageBy & data$Province == provinceBy,
                       -c("Geocode","CACode","Age","latitude","longitude"),
                       with=FALSE]
        }
        setnames(df,c("City/Division","Province/Territory","Total population","%","% of change",
                      "English","%","% of change",
                      "French","%","% of change",
                      "Both languages","%","% of change",
                      "Neither language","%","% of change"))
        DT::datatable(df)
    })
}

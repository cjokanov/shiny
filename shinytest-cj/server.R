#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

download.file("https://www.who.int/childgrowth/standards/lhfa_boys_p_exp.txt", "./boys.txt")
download.file("https://www.who.int/childgrowth/standards/lhfa_girls_p_exp.txt", "./girls.txt")
data_boys<-read.delim("./boys.txt", dec=".")
data_girls<-read.delim("./girls.txt", dec=".")
data_boys$gender="boys"
data_girls$gender="girls"
data_bg<-rbind(data_boys,data_girls)

rm(data_boys)
rm(data_girls)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # select Day range based on input in ui.R
        rng<-input$from

        dayfrom=rng[1]*30.4375
        dayto=rng[2]*30.4375
        
        data_out<-subset(data_bg,Day>=dayfrom)
        data_out<-subset(data_out,Day<=dayto)
        
        # draw the line plot of median height
        if(input$percentiles){
            ggplot(data_out) + aes(Day,M,group=gender) + 
                geom_ribbon(aes(ymin = P25, ymax = P75), fill = "grey70") +
                 geom_line(aes(Day,M,group=gender,color=gender))
               
        }
        else{
            ggplot(data_out) + aes(Day,M,group=gender,color=gender) + geom_point(shape=".")
        }

    })

})

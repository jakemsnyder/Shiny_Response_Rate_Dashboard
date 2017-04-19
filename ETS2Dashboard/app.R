library(shiny)
library(tidyverse)
library(ggplot2)
library(scales)

# Set working directory to app folder before launch!!!
update <- read.table('LastUpdate.txt',sep=',',header=F,stringsAsFactors=F)
data <- read.csv('data.csv')
overall.rate <- paste0(round(mean(data$Finished,na.rm=T),3)*100,"%")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Survey Response Rates"),
   h6(paste0("Last update: ",update)),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
          selectInput("demographic","Demographic:",
                    list('Vendor System'='Vendor.System',
                         'Agency'='Agency')
                    ),
          h5("Overall Response Rate: ",
             br(),
             div(overall.rate,style = "color:green;
                                       font-size:200%;")),
          width=3
          ),
      
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("responsePlot",
                   height=600,
                   width=1000)

#       ,tableOutput(outputId='table')
         
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  
#    output$table <- renderTable({
#      data %>% group_by_(input$demographic) %>% summarise(Response.Rate=mean(Finished))
#    })
    
    
    dat <- reactive({
      data %>% group_by_(input$demographic) %>% summarise(Response.Rate=mean(Finished),Count=sum(Finished))
    })
    
    
    
    output$responsePlot <- renderPlot({
      
    ggplot(dat(),aes_string(x=input$demographic, y='Response.Rate',fill='Response.Rate')) +
        geom_bar(stat="identity",colour='grey') + 
        labs(x=input$demographic, y="Response Rate") +
        scale_fill_gradient2(oob=squish,limits=c(0,0.4),low='white',high='#076815',
                             mid='#2ea03f',midpoint=0.2,name='Response Rate') +
        geom_text(aes(label=paste(Count,'; ',round(Response.Rate,3)*100,'%',sep='')),hjust=-0.1) +
        scale_y_continuous(expand = c(0.15, 0)) +
        coord_flip() + theme_bw(base_size=16) +
        theme(axis.ticks.y=element_blank(),panel.grid.major.y=element_blank())
   })
}


# Run the application 
shinyApp(ui = ui, server = server)


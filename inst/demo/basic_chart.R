# Demo file

# 
###############################################################################

library(shinyGoogleCharts)

#Basic Example
runApp(list(
  ui = fluidPage(fluidRow(column(8, googleChartOutput('chart1')))),
  
  server = function(input, output, session) { 
    output$chart1 <- renderGoogleChart({
      googleChart(
        data = subset(mtcars, select = c('cyl','mpg')), 
        type = 'ScatterChart'
      )
    })
  }
))

#With options
runApp(list(
  ui = fluidPage(googleChartOutput('chart2')),
  
  server = function(input, output, session) { 
    output$chart2 <- renderGoogleChart({
      googleChart(
        data = subset(mtcars, select = c('cyl','mpg')), 
        type = 'ScatterChart',
        options=list(
          title = 'Mtcars: Cylinders v MPG',
          hAxis = list(title = 'Number of Cylinders'),
          vAxis = list(title = 'Miles Per Gallon (mpg)'),
          height = 400,
          width = 600
        )
      )
    })
  }
))

#Chart Editor
#library(dplyr)

runApp(list(
  ui = fluidPage(
    fluidRow(column(12, googleChartOutput('chart3'))),
    googleChartEditor('chart3_editor', 'chart3'),
    h4('Chart Options'),
    verbatimTextOutput('chart3_opts')
    ),
  
  server = function(input, output, session) { 
    output$chart3_opts <- renderPrint({input$chart3_editor})
    output$chart3 <- renderGoogleChart({
      mtcars_sub <- subset(mtcars, select = c('disp','mpg', 'wt'))
      googleChart(
        data = mtcars_sub[order(1:nrow(mtcars_sub), mtcars_sub$disp),], 
        type = input$chart3_editor$chartType,
        options = fromJSON(input$chart3_editor$options)
      )
    })
  }
))

# options: useFirstColumnAsDomain:true



# formatData <- function(data){  
#   
#   #Define data type for each column
#   formatted_data <- list()
#   formatted_data$data.type <-
#   sapply(data, function(x){
#     switch(class(x), 
#            'numeric' = 'number', 
#            'integer' = 'number',
#            "character"="string",
#            "factor"="string",
#            "logical"="boolean",
#            "Date"="date",
#            "POSIXct"="datetime",
#            "POSIXlt"="datetime")})
#   
#   #Convert data to row array format
#   t_data <- as.data.frame(t(data))
#   formatted_data$json <- toJSON(as.list(t_data), .withNames = F, container = T, pretty = T)
#   #formatted_data$json <- str_replace_all(toJSON(as.list(t_data), .withNames = F, container = T), ' ', '')
#   formatted_data
# }
# 
# #Test equality
# mtcars_sub <- subset(mtcars, select = c('cyl','mpg'))
# x <- formatData(mtcars_sub)
# y <- googleVis:::gvisFormat(mtcars_sub)  
# identical(fromJSON(x$json), fromJSON(y$json))
# identical(x$data.type, y$data.type)

library(shinyGoogleCharts)
library(RJSONIO)

#Basic Example
runApp(list(
  ui = fluidPage(googleChartOutput('gchart1')),
  
  server = function(input, output, session) { 
    output$gchart1 <- renderGoogleChart({
      googleChart(
        data = subset(mtcars, select = c('cyl','mpg')), 
        type = 'ScatterChart'
      )
    })
  }
))

#With options
runApp(list(
  ui = fluidPage(googleChartOutput('gchart1')),
  
  server = function(input, output, session) { 
    output$gchart1 <- renderGoogleChart({
      googleChart(
        data = subset(mtcars, select = c('cyl','mpg')), 
        type = 'ScatterChart',
        options=list(
          title = 'Mtcars: Cylinders v MPG',
          hAxis = list(title = 'Number of Cylinders'),
          vAxis = list(title = 'Miles Per Gallon (mpg)')#,
          #height = 400,
          #width = 600
        )
      )
    })
  }
))

#Chart Editor
runApp(list(
  ui = fluidPage(
    fluidRow(column(12, googleChartOutput('chartgItemPlot1'))),
    googleChartEditor('chartgItemPlot1_editor', 'chartgItemPlot1'),
    h4('Chart Options'),
    verbatimTextOutput('chartgItemPlot1_opts')
    ),
  
  server = function(input, output, session) { 
    output$chartgItemPlot1_opts <- renderPrint({input$chartgItemPlot1_editor})
    output$chartgItemPlot1 <- renderGoogleChart({
      googleChart(
        data = subset(mtcars, select = c('cyl','mpg')), 
        type = input$chartgItemPlot1_editor$chartType,
        options = fromJSON(input$chartgItemPlot1_editor$options)
      )
    })
  }
))
library(shiny)
library(shinyGoogleCharts)
library(RJSONIO)
library(dplyr)
library(googleVis)

coffee_data <-
  as.data.frame(rbind(
    c(165,      938,         522,             998,           450,      614.6),
    c(135,      1120,        599,             1268,          288,      682),
    c(157,      1167,        587,             807,           397,      623),
    c(139,      1110,        615,             968,           215,      609.4),
    c(136,      691,         629,             1026,          366,      569.6)))
names(coffee_data) <- c('Bolivia', 'Ecuador', 'Madagascar', 'Papua', 'Rwanda', 'Average')
coffee_data$Month <- c('2004/05/01', '2005/06/01', '2005/07/01', '2005/08/01', '2005/09/01')
coffee_data <- select(coffee_data, Month, Bolivia, Ecuador, Madagascar, Papua, Rwanda, Average) 

str(coffee_data)


plot(gvisComboChart(
  data = coffee_data, 
  xvar = 'Month', 
  yvar = c('Bolivia', 'Ecuador', 'Madagascar', 'Papua', 'Rwanda', 'Average'), 
  options = list(
    seriesType = 'lines',
    series = '{5: {type:"bars"}}'
  )))



#With options
runApp(list(
  ui = fluidPage(googleChartOutput('gchart1')),
  
  server = function(input, output, session) { 
    output$gchart1 <- renderGoogleChart({
      googleChart(
        data = coffee_data, 
        type = 'ComboChart',
        options=list(
          title = 'Mtcars: Cylinders v MPG',
          hAxis = list(title = 'Cups'),
          vAxis = list(title = 'Month'),
          seriesType = 'bars'#,
          #series =  list('5' = list(type = 'line'))
        )
      )
    })
  }
))
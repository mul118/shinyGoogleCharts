#' Convert data frame into a row array JSON + list of column datatypes
#' 
#' @import RJSONIO 
formatData <- function(data){  
  
  #Define data type for each column
  formatted_data <- list()
  formatted_data$data.type <-
    sapply(data, function(x){
      switch(class(x), 
             'numeric' = 'number', 
             'integer' = 'number',
             "character"="string",
             "factor"="string",
             "logical"="boolean",
             "Date"="date",
             "POSIXct"="datetime",
             "POSIXlt"="datetime")})
  
  #Convert data to row array format
  t_data <- as.data.frame(t(data))
  formatted_data$json <- toJSON(as.list(t_data), .withNames = F, container = T, pretty = T)
  #formatted_data$json <- str_replace_all(toJSON(as.list(t_data), .withNames = F, container = T), ' ', '')
  formatted_data
}


#' Generate a Google Chart object
#' 
#' @import RJSONIO 
#' @param data data frame to render as a Google chart. The mappings (xvar, yvar, etc.) are determined by column order and chart type.
#' @param type chart type
#' @param options chart options
#' @export
googleChart   <- function(data, type = 'Table', options = list()){
  formatData      <- formatData(data)
  #formatted_data  <- googleVis:::gvisFormat(data)
  dataLabels      <- toJSON(formatted_data$data.type)
  dataJSON        <- formatted_data$json
  optionsJSON     <- toJSON(options)
  return(list(dataLabels = dataLabels, dataJSON = dataJSON, chartType = type, options = optionsJSON))
}

#' Render A Google Chart
#'
#' @param expr an expression that returns a data frame
#' @param env The environment in which to evaluate \code{expr}
#' @param quoted is expr a quoted expression? This is useful if you want to save an expression in a variable.
#' @export
renderGoogleChart <- function(expr, env=parent.frame(), quoted = FALSE){
  func <- exprToFunction(expr, env, quoted)
  function(){ 
    val <- func()
    val
  }
}

#' Google Chart output element
#'
#' Display a \link{renderGoogleChart} object within an application page.
#' @param chartId output variable to read the plot from
#' @return a plot output element that can be included in a panel
#' @examples
#' # Show a Google Line Chart
#' mainPanel(
#'   googleChartOutput("myLineChart")
#' )
#' @import shiny
#' @export
googleChartOutput <- function(chartId){
  addResourcePath(prefix = 'shinyGoogleCharts', directoryPath = system.file('www', package = 'shinyGoogleCharts'))
  tagList( 
    singleton(HTML('<script type="text/javascript" src="//www.google.com/jsapi"></script>')),
    singleton(tags$script(src = 'shinyGoogleCharts/googleChart.js')),
    #singleton(includeScript(paste0(system.file('www', package = 'shinyGoogleCharts'), '/googleChart.js'))),
    HTML(paste0('<div id = "', chartId, '" class="shinyGoogleChart" style = "width:100%; height:100%; overflow-y: hidden; overflow-x: hidden"></div>'))
  )
}

#' Shiny Chart Editor output element
#' 
#' Display a Chart Editor button within an application page.  Displays a GUI allowing user to modify properties of the target chart.
#' @param editorId id of the chart editor, available as an input variable
#' @param chartId id of the \link{renderGoogleChart} object modified by the editor
#' @param type initial type of the target chart.  Defaults to 'Table'
#' @param options initial options of the target chart
#' @param label label for the Chart Editor button
#' @import shiny
#' @export
googleChartEditor <- function(editorId, chartId, type = 'Table', options = list(), label = 'Edit Chart'){
  addResourcePath(prefix = 'shinyGoogleCharts', directoryPath = system.file('www', package = 'shinyGoogleCharts'))
  tagList(
    singleton(HTML('<script type="text/javascript" src="//www.google.com/jsapi"></script>')),
    singleton(tags$script(src = 'shinyGoogleCharts/googleChart.js')),
    
    #ChartEditor Button  
    HTML(paste0("<div class = 'chartEditor btn' style='display:inline;' onclick='openChartEditor(\"", editorId, "\", \"", chartId, 
                "\");' data-target = '", chartId, "' options = '", toJSON(options),
                "' chartType = '", type,"' id = '", editorId,"'>", label, "</div> ")),
    
    singleton(tags$script(
      "var openChartEditor = function(editorId, chartId){
        var wrapper = $('#'+chartId).data('chart');
        var editor = new google.visualization.ChartEditor();
        google.visualization.events.addListener(editor, 'ok',
             function() {
              var new_wrapper = editor.getChartWrapper();
              new_wrapper.draw($('#'+chartId));
              $('#'+chartId).data('chart', new_wrapper);
              $('#'+editorId).attr('chartType', new_wrapper.getChartType());
              $('#'+editorId).attr('options', JSON.stringify(new_wrapper.getOptions()));
              $('#'+editorId).trigger('change.chartEditorInputBinding');
            }
        );
        editor.openDialog(wrapper);
        };"))
    
  )}
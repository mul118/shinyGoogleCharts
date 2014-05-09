#' Generate a Google Chart object
#' 
#' @import RJSONIO 
#' @param data data frame to render as a Google chart. The mappings (xvar, yvar, etc.) are determined by column order and chart type.
#' @param type chart type
#' @param options chart options
#' @export
googleChart   <- function(data, type = 'Table', options = list()){
  formatted_data  <- googleVis:::gvisFormat(data)
  dataLabels      <- toJSON(formatted_data$data.type)
  dataJSON        <- formatted_data$json
  optionsJSON     <- toJSON(options)
  return(list(dataLabels = dataLabels, dataJSON = dataJSON, chartType = type, options = optionsJSON))
}

#' Render A Google Chart
#'
#' @param expr an expression that returns a data frame
#' @param env The environment in which to evaluate \code{expr}
#' @param qoted is expr a quoted expression (with \code{quote()})? This is useful if you want to save an expression in a variable.
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
#' @param outputId output variable to read the plot from
#' @return a plot output element that can be included in a panel
#' @examples
#' # Show a Google Line Chart
#' mainPanel(
#'   googleChartOutput("myLineChart")
#' )
#' @import shiny
#' @export
googleChartOutput <- function(outputId){
  tagList( 
    #addResourcePath(prefix = 'shinyGoogleCharts', 
    singleton(HTML('<script type="text/javascript" src="//www.google.com/jsapi"></script>')),
    singleton(includeScript(paste0(system.file('www', package = 'shinyGoogleCharts'), '/googleChart.js'))),
    HTML(paste0('<div id = "', outputId, '" class="shinyGoogleChart" style = "width:100%; height:100%; overflow-y: hidden; overflow-x: hidden"></div>'))
  )
}

#' Shiny Chart Editor output element
#' 
#' Display a Chart Editor button within an application page.  Displays a GUI allowing user to modify properties of the target chart.
#' @param inputId id of the chart editor, available as an input variable
#' @param targetId id of the \link{renderGoogleChart} object modified by the editor
#' @param type initial type of the target chart.  Defaults to 'Table'
#' @param options initial options of the target chart
#' @param label label for the Chart Editor button
#' @import shiny
#' @export
googleChartEditor <- function(inputId, target, type = 'Table', options = list(), label = 'Edit Chart'){tagList(
  singleton(HTML('<script type="text/javascript" src="//www.google.com/jsapi"></script>')),
  singleton(includeScript(paste0(system.file('www', package = 'shinyGoogleCharts'), '/googleChart.js'))),
  
  #ChartEditor Button  
  HTML(paste0("<div class = 'chartEditor btn' style='display:inline;' onclick='openChartEditor(\"", target, 
     "\");' data-target = '", target, "' options = '", toJSON(options),
     "' chartType = '", type,"' id = '", inputId,"'>",label,"</div> ")),

  singleton(tags$script(
       "var openChartEditor = function(chartId){
        var wrapper = $('#'+chartId).data('chart');
        var editor = new google.visualization.ChartEditor();
        google.visualization.events.addListener(editor, 'ok',
             function() {
              var new_wrapper = editor.getChartWrapper();
              new_wrapper.draw($('#'+chartId));
              $('#'+chartId).data('chart', new_wrapper);
              $('#'+chartId+'_editor').attr('chartType', new_wrapper.getChartType());
              $('#'+chartId+'_editor').attr('options', JSON.stringify(new_wrapper.getOptions()));
              $('#'+chartId+'_editor').trigger('change.chartEditorInputBinding');
            }
        );
        editor.openDialog(wrapper);
        };"))
            
)}
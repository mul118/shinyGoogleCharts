#' Generate a Google Chart object
#' 
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
#' Render a \link{renderGoogleChart} within an application page.
#' @param outputId output variable to read the plot from
#' @return a plot output element that can be included in a panel
#' @examples
#' # Show a Google Line Chart
#' mainPanel(
#'   googleChartOutput("myLineChart")
#' )
#' @export
googleChartOutput <- function(outputId){tagList(
  singleton(HTML('<script type="text/javascript" src="//www.google.com/jsapi"></script>')),
  singleton(includeScript(paste0(getwd(),'/www/googleChart.js'))),
  HTML(paste0('<div id = "', outputId, '" class="shinyGoogleChart" style = "width:100%; height:100%; overflow-y: hidden; overflow-x: hidden"></div>'))
)}

#' Shiny Chart Editor output element
#' 
#' @export
googleChartEditor <- function(id, target, type = 'Table', options = '{}', label = 'Edit Chart'){tagList(
  singleton(HTML('<script type="text/javascript" src="//www.google.com/jsapi"></script>')),
  singleton(includeScript(paste0(getwd(),'/www/googleChart.js'))),
  
  #ChartEditor Button  
  HTML(paste0("<div class = 'chartEditor btn' style='display:inline;' onclick='openChartEditor(\"", target, 
     "\");' data-target = '", target, "' options = '", options,
     "' chartType = '", type,"' id = '", id,"'>",label,"</div> ")),

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
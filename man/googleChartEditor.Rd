\name{googleChartEditor}
\alias{googleChartEditor}
\title{Shiny Chart Editor output element}
\usage{
googleChartEditor(editorId, chartId, type = "Table", options = list(),
  label = "Edit Chart")
}
\arguments{
  \item{editorId}{id of the chart editor, available as an
  input variable}

  \item{chartId}{id of the \link{renderGoogleChart} object
  modified by the editor}

  \item{type}{initial type of the target chart.  Defaults
  to 'Table'}

  \item{options}{initial options of the target chart}

  \item{label}{label for the Chart Editor button}
}
\description{
Display a Chart Editor button within an application page.
Displays a GUI allowing user to modify properties of the
target chart.
}


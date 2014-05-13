\name{googleChartOutput}
\alias{googleChartOutput}
\title{Google Chart output element}
\usage{
googleChartOutput(chartId)
}
\arguments{
  \item{chartId}{output variable to read the plot from}
}
\value{
a plot output element that can be included in a panel
}
\description{
Display a \link{renderGoogleChart} object within an
application page.
}
\examples{
# Show a Google Line Chart
mainPanel(
  googleChartOutput("myLineChart")
)
}


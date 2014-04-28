\name{googleChartOutput}
\alias{googleChartOutput}
\title{Google Chart output element}
\usage{
googleChartOutput(outputId)
}
\arguments{
  \item{outputId}{output variable to read the plot from}
}
\value{
a plot output element that can be included in a panel
}
\description{
Render a \link{renderGoogleChart} within an application
page.
}
\examples{
# Show a Google Line Chart
mainPanel(
  googleChartOutput("myLineChart")
)
}


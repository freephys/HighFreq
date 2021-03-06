% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{sim_arima}
\alias{sim_arima}
\title{Recursively filter a \emph{vector} of innovations through a \emph{vector} of
\emph{ARIMA} coefficients.}
\usage{
sim_arima(in_nov, co_eff)
}
\arguments{
\item{in_nov}{A \emph{vector} of innovations (random numbers).}

\item{co_eff}{A \emph{vector} of \emph{ARIMA} coefficients.}
}
\value{
A column \emph{vector} of the same length as the argument
  \code{in_nov}.
}
\description{
Recursively filter a \emph{vector} of innovations through a \emph{vector} of
\emph{ARIMA} coefficients.
}
\details{
The function \code{sim_arima()} recursively filters a \emph{vector}
  of innovations through a \emph{vector} of \emph{ARIMA} coefficients, using
  \code{RcppArmadillo}.
  It performs the same calculation as the standard \code{R} function
  \code{filter(x=in_nov, filter=co_eff, method="recursive")}, but it's over
  \code{6} times faster.
}
\examples{
\dontrun{
# Create vector of innovations
in_nov <- rnorm(100)
# Create ARIMA coefficients
co_eff <- c(-0.8, 0.2)
# Calculate recursive filter using filter()
filter_ed <- filter(in_nov, filter=co_eff, method="recursive")
# Calculate recursive filter using RcppArmadillo
ari_ma <- HighFreq::sim_arima(in_nov, rev(co_eff))
# Compare the two methods
all.equal(as.numeric(ari_ma), as.numeric(filter_ed))
}

}

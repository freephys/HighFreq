% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/HighFreq.R
\name{scrub_taq}
\alias{scrub_taq}
\title{Scrub a single day of \emph{TAQ} data in \emph{xts} format, without
aggregation.}
\usage{
scrub_taq(ta_q, look_back = 51, vol_mult = 2,
  tzone = "America/New_York")
}
\arguments{
\item{ta_q}{\emph{TAQ} A time series in \emph{xts} format.}

\item{look_back}{The number of data points in rolling look-back interval for 
estimating rolling quantile.}

\item{vol_mult}{The quantile multiplier.}

\item{tzone}{The timezone to convert.}
}
\value{
A \emph{TAQ} time series in \emph{xts} format.
}
\description{
Scrub a single day of \emph{TAQ} data in \emph{xts} format, without
aggregation.
}
\details{
The function \code{scrub_taq()} performs the same scrubbing
  operations as \code{scrub_agg}, except it doesn't aggregate, and returns
  the \emph{TAQ} data in \emph{xts} format.
}
\examples{
ta_q <- HighFreq::scrub_taq(ta_q=HighFreq::SPY_TAQ, look_back=11, vol_mult=1)
# Create random TAQ prices and scrub them
ta_q <- HighFreq::random_taq()
ta_q <- HighFreq::scrub_taq(ta_q=ta_q)
ta_q <- HighFreq::scrub_taq(ta_q=ta_q, look_back=11, vol_mult=1)
}

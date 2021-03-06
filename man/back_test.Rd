% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{back_test}
\alias{back_test}
\title{Simulate (backtest) a rolling portfolio optimization strategy, using
\code{RcppArmadillo}.}
\usage{
back_test(ex_cess, re_turns, start_points, end_points,
  typ_e = "max_sharpe", max_eigen = 1L, quan_tile = 0.1,
  al_pha = 0, scal_e = TRUE, co_eff = 1, bid_offer = 0)
}
\arguments{
\item{ex_cess}{A \emph{matrix} of excess returns data (the returns
in excess of the risk-free rate).}

\item{re_turns}{A \emph{matrix} of excess returns data (the returns
in excess of the risk-free rate).}

\item{start_points}{An \emph{integer vector} of start points.}

\item{end_points}{An \emph{integer vector} of end points.}

\item{typ_e}{A \emph{string} specifying the objective for calculating the
weights (see Details).}

\item{max_eigen}{An \emph{integer} equal to the number of eigenvectors used
for calculating the regularized inverse of the covariance \emph{matrix}
(the default is the number of columns of \code{re_turns}).}

\item{al_pha}{A numeric shrinkage intensity.  (The default is \code{0})}

\item{scal_e}{A \emph{Boolean} specifying whether the weights should be
scaled (the default is \code{scal_e=TRUE}).}

\item{co_eff}{A numeric multiplier of the weights.  (The default is
\code{1})}

\item{bid_offer}{A numeric bid-offer spread.  (The default is \code{0})}
}
\value{
A column \emph{vector} of strategy returns, with the same length as
  the number of rows of \code{re_turns}.
}
\description{
Simulate (backtest) a rolling portfolio optimization strategy, using
\code{RcppArmadillo}.
}
\details{
The function \code{back_test()} performs a backtest simulation of a
  rolling portfolio optimization strategy over a \emph{vector} of
  \code{end_points}.
  
  It performs a loop over the \code{end_points}, and subsets the
  \emph{matrix} of excess returns \code{ex_cess} along its rows, between the
  corresponding end point and the start point. It passes the subset matrix
  of excess returns into the function \code{calc_weights()}, which
  calculates the optimal portfolio weights. The arguments \code{max_eigen},
  \code{al_pha}, \code{typ_e}, and \code{scal_e} are also passed to the
  function \code{calc_weights()}.
  
  The function \code{back_test()} multiplies the weights by the coefficient
  \code{co_eff} (with default equal to \code{1}), which allows reverting a
  strategy if \code{co_eff = -1}.
  
  The function \code{back_test()} then multiplies the weights times the
  future portfolio returns, to calculate the out-of-sample strategy returns.
  
  The function \code{back_test()} calculates the transaction costs by
  multiplying the bid-offer spread \code{bid_offer} times the absolute
  difference between the current weights minus the weights from the previous
  period. It then subtracts the transaction costs from the out-of-sample
  strategy returns.
  
  The function \code{back_test()} returns a \emph{time series} (column
  \emph{vector}) of strategy returns, of the same length as the number of
  rows of \code{re_turns}.
}
\examples{
\dontrun{
# Calculate the ETF daily excess returns
re_turns <- na.omit(rutils::etf_env$re_turns[, 1:16])
# risk_free is the daily risk-free rate
risk_free <- 0.03/260
ex_cess <- re_turns - risk_free
# Define monthly end_points without initial warmpup period
end_points <- rutils::calc_endpoints(re_turns, inter_val="months")
end_points <- end_points[end_points>50]
len_gth <- NROW(end_points)
# Define 12-month look_back interval and start_points over sliding window
look_back <- 12
start_points <- c(rep_len(1, look_back-1), end_points[1:(len_gth-look_back+1)])
# Define shrinkage and regularization intensities
al_pha <- 0.5
max_eigen <- 3
# Simulate a monthly rolling portfolio optimization strategy
pnl_s <- HighFreq::back_test(ex_cess, re_turns, 
                            start_points-1, end_points-1, 
                            max_eigen = max_eigen, 
                            al_pha = al_pha)
pnl_s <- xts::xts(pnl_s, index(re_turns))
colnames(pnl_s) <- "strat_rets"
# Plot dygraph of strategy
dygraphs::dygraph(cumsum(pnl_s), 
  main="Cumulative Returns of Max Sharpe Portfolio Strategy")
}

}

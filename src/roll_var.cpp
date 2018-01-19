#include <Rcpp.h>
using namespace Rcpp;

//' Calculate a time series of variance estimates over a rolling look-back interval
//' for an \emph{OHLC} time series of prices, using different range estimators
//' for variance.
//'
//' @param oh_lc An \emph{OHLC} time series of prices in \emph{xts} format.
//' @param calc_method \emph{character} string representing method for estimating
//'   variance.  The methods include:
//'   \itemize{
//'     \item "close" close to close,
//'     \item "garman_klass" Garman-Klass,
//'     \item "garman_klass_yz" Garman-Klass with account for close-to-open price jumps,
//'     \item "rogers_satchell" Rogers-Satchell,
//'     \item "yang_zhang" Yang-Zhang,
//'    }
//'    (default is \code{"yang_zhang"})
//' @param look_back The size of the look-back interval, equal to the number of rows
//'   of data used for calculating the variance.
//' @param sca_le \emph{Boolean} argument: should the returns be divided by the
//'   number of seconds in each period? (default is \code{TRUE})
//'
//' @return An \emph{xts} time series with a single column and the same number of
//'   rows as the argument \code{oh_lc}.
//'
//' @details The function \code{roll_var()} calculates a time series of rolling 
//'   variance variance estimates of percentage returns, from over a
//'   \emph{vector} of returns, using several different variance estimation
//'   methods based on the range of \emph{OHLC} prices.
//'
//'   If \code{sca_le} is \code{TRUE} (the default), then the variance is divided
//'   by the squared differences of the time index (which scales the variance to
//'   units of variance per second squared.) This is useful for example, when
//'   calculating intra-day variance from minutely bar data, because dividing
//'   returns by the number of seconds decreases the effect of overnight price
//'   jumps.
//'
//'   If \code{sca_le} is \code{TRUE} (the default), then the variance is
//'   expressed in the scale of the time index of the \emph{OHLC} time series.
//'   For example, if the time index is in seconds, then the variance is given in
//'   units of variance per second squared.  If the time index is in days, then
//'   the variance is equal to the variance per day squared.
//'
//'   The time index of the \code{oh_lc} time series is assumed to be in
//'   \emph{POSIXct} format, so that its internal value is equal to the number of
//'   seconds that have elapsed since the \emph{epoch}.
//'
//'   The methods \code{"close"}, \code{"garman_klass_yz"}, and
//'   \code{"yang_zhang"} do account for close-to-open price jumps, while the
//'   methods \code{"garman_klass"} and \code{"rogers_satchell"} do not account
//'   for close-to-open price jumps.
//'
//'   The default method is \code{"yang_zhang"}, which theoretically has the
//'   lowest standard error among unbiased estimators.
//'
//'   The function \code{roll_var()} performs the same calculations as the
//'   function \code{volatility()} from package
//'   \href{https://cran.r-project.org/web/packages/TTR/index.html}{TTR}, but
//'   it's a little faster because it uses function RcppRoll::roll_sd(), and it
//'   performs less data validation.
//'
//' @examples
//' \dontrun{
//' # create minutely OHLC time series of random prices
//' oh_lc <- HighFreq::random_ohlc()
//' # calculate variance estimates for oh_lc over a 21 period interval
//' var_rolling <- HighFreq::roll_var(oh_lc, look_back=21)
//' # calculate variance estimates for SPY
//' var_rolling <- HighFreq::roll_var(HighFreq::SPY, calc_method="yang_zhang")
//' # calculate SPY variance without accounting for overnight jumps
//' var_rolling <- HighFreq::roll_var(HighFreq::SPY, calc_method="rogers_satchell")
//' }

//' @export
// [[Rcpp::export]]

NumericVector roll_var(NumericVector re_turns, int look_back) {
  int len_gth = re_turns.size();
  NumericVector var_iance(len_gth);
  NumericVector mean_s(len_gth);
  
  var_iance[look_back-1] = sum(re_turns[Range(0, (look_back-1))]);
  for (int i = look_back; i < len_gth; ++i) {
//    var_iance[i] = var_iance[i-1] * exp(re_turns[i]);
    var_iance[i] = var_iance[i] + re_turns[i] - re_turns[i-look_back];
  }
  
  return var_iance;
}
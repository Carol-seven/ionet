#include <Rcpp.h>
#include "dijkstra.h"

using namespace Rcpp;

//' Betweenness centrality
//'
//' Compute the betweenness centrality with prior information based on strongest path (SP).
//'
//' @param adjmat The matrix of intermediate transactions in the input-output table,
//' a n-by-n matrix.
//' @param gross The gross input/output, a n-by-1 vector.
//' @param prior The node-specific prior information, a n-by-1 vector.
//' @param alpha The tuning parameter controlling the weights for SP strength and
//' prior information. The default setting is 1.
//' @param type Which type of SP to calculate: "consumption"/"pull" (default) or "distribution"/"push".
//' @return Lists of betweeness score, associated SPs, SP distance and SP strength.
//' @export
// [[Rcpp::export]]
List btw(NumericMatrix adjmat,
         NumericVector gross,
         NumericVector prior,
         double alpha = 1,
         String type = "consumption") {

  int n = adjmat.ncol();

  if (gross.length() != n) {
    stop("The dimension of the gross input/output vector is incorrect!");
  }
  if (prior.length() != n) {
    stop("The dimension of the prior information is incorrect!");
  }
  if (sum(prior) == 0 || Rcpp::is_true(Rcpp::any(prior < 0))) {
    stop("The prior information is invalid!");
  }
  if (alpha < 0 || alpha > 1) {
    stop("The tuning parameter alpha is not between 0 and 1!");
  }

  NumericMatrix adj(n, n);
  if (type == "consumption" || type == "pull") {
    for (int i=0; i < n; i++) {
      adj(_,i) = -log(adjmat(_,i) / gross[i]);
    }
  } else if (type == "distribution" || type == "push") {
    for (int i=0; i < n; i++) {
      adj(i,_) = -log(adjmat(i,_) / gross[i]);
    }
  }

  NumericVector distance(n*n);
  IntegerVector prevnode(n*n, NA_INTEGER);
  for (int i = 0; i < n; i++) {
    List tmp = dijkstra(adj, i+1);
    NumericVector tmpdist = tmp["distance"];
    IntegerVector tmpprev = tmp["prevnode"];
    tmpdist = exp(-tmpdist);
    for (int j = 0; j < n; j++) {
      if (tmpprev[j] != NA_INTEGER) {
        distance[i*n+j] = tmpdist[j];
        prevnode[i*n+j] = tmpprev[j] - 1;
      }
    }
  }

  List allpath(n*n);
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      if (prevnode[i*n+j] != NA_INTEGER) {
        int last_node = j;
        IntegerVector tmp;
        while(last_node != NA_INTEGER) {
          tmp.push_front(last_node);
          last_node = prevnode[i*n+last_node];
        }
        allpath[i*n+j] = tmp + 1;
      }
    }
  }

  NumericVector strength;
  if (type == "consumption" || type == "pull") {
    strength = distance * rep(gross, n);
  } else if (type == "distribution" || type == "push") {
    strength = distance * rep_each(gross, n);
  }

  NumericVector btwscore(n);
  for (int j = 0; j < n*n; j++) {
    if (allpath[j] != R_NilValue) {
      IntegerVector path = allpath[j];
      int m = path.length();
      if (type == "consumption" || type == "pull") {
        int source = path[0] - 1;
        for (int k = 1; k < m-1; k++) {
          int temp = path[k] - 1;
          btwscore[temp] = btwscore[temp] +
            pow(strength[j], alpha) * pow(prior[source], 1-alpha);
        }
      } else if (type == "distribution" || type == "push") {
        int target = path[m-1] - 1;
        for (int k = 1; k < m-1; k++) {
          int temp = path[k];
          btwscore[temp] = btwscore[temp] +
            pow(strength[j], alpha) * pow(prior[target], 1-alpha);
        }
      }
    }
  }

  return List::create(Named("btwscore") = btwscore,
                      // Named("prevnode") = prevnode + 1,
                      Named("path") = allpath,
                      Named("distance") = distance,
                      Named("strength") = strength);
}

#include <Rcpp.h>
using namespace Rcpp;

/*
 Dijkstra's algorithms
 Adapted from
 https://www.includehelp.com/cpp-tutorial/dijkstras-algorithm.aspx
 by Shubham Singh Rajawat
 to allow different definitions of distance.
*/

// Find the node with minimum distance which is not yet included in doneSet
int minDist(NumericVector dist, LogicalVector doneSet) {
  double min = R_PosInf;
  int nnode = dist.length(), index;
  // initialize min with the maximum possible value as infinity does not exist
  for (int v = 0; v < nnode; v++) {
    if(!doneSet[v] && dist[v] <= min) {
      min = dist[v];
      index = v;
    }
  }
  return index;
}


//' Dijkstra's algorithm
//'
//' Implement the Dijkstra's algorithm to find the shortest paths
//' from the source node to all nodes in the given network.
//'
//' @param adjmat The adjacency matrix of an directed and weighted network.
//' @param src The given source node to find the shortest distance.
//' @references Dijkstra, E. W. (1959).
//' "A Note on Two Problems in Connexion with Graphs".
//' \emph{Numerische Mathematik}, 1, 269--271.
//' @return Lists of distance, previous node.
//' @export
// [[Rcpp::export]]
List dijkstra(NumericMatrix adjmat, int src) {
  if (adjmat.nrow() != adjmat.ncol()) {
    stop("The intermediate flow matrix is not a square matrix!");
  }
  int nnode = adjmat.ncol();
  if (src < 1 || src > nnode) stop("Inadmissible value for `src'");
  src = src - 1; // convert to indexing starting from zero
  LogicalVector doneSet(nnode, false);   // nodes that have been processed
  NumericVector dist(nnode, R_PosInf);   // distance from the src node
  IntegerVector prev(nnode, NA_INTEGER); // prev node set to NA

  dist[src] = 0; // initialize the distance of the source node to zero
  for (int i = 0; i < nnode; i++) {
    // u is the node that is not processed yet and has minimum distance to src
    int u = minDist(dist, doneSet);
    doneSet[u] = true; // label u as processed
    for (int v = 0; v < nnode; v++) {
      if (!doneSet[v] && adjmat(u, v) && dist[u] != R_PosInf) {
        // get the distance of the path from src to v immediately through u
        double altdist = dist[u] + adjmat(u, v);
        if (altdist < dist[v]) {
          // update distance and record prevnode
          dist[v] = altdist;
          prev[v] = u;
        }
      }
    }
  }

  return List::create(Named("distance") = dist,
                      // back to indexing starting from 1
                      Named("prevnode") = prev + 1);
}

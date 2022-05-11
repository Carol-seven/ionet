#' Betweenness centrality
#'
#' Compute the betweenness centrality with priors based on strongest path.
#'
#' @param adjmat is a square matrix of intermediate transactions in the input-output table.
#' @param gross is the total input/output vector.
#' @param prior is the vector containing node-specific prior information.
#' @param alpha is the tuning parameter controlling the weights for SP strength and
#' prior information.
#' @param type which type of SP to calculate: "consumption" or "distribution".
#'
#' @return a list of the betweeness centrality (vector), associated SP (matrix recording
#' the intermediate vertices) and SP strength (matrix) for all vertices.
#' @export


btw <- function(adjmat,
                gross,
                prior = rep(1, dim(adjmat)[1]),
                alpha = 1,
                type = c("consumption", "distribution")) {

  if (dim(adjmat)[1] != dim(adjmat)[2]) {
    stop("The intermediate flow matrix is not a square matrix!")
  }
  if (length(gross) != dim(adjmat)[1]) {
    stop("The dimension of the total input/output vector is incorrect!")
  }
  if (length(prior) != dim(adjmat)[1]) {
    stop("The dimension of the prior information is incorrect!")
  }
  if ((sum(prior) == 0) | any(prior < 0)){
    stop("The prior information is invalid!")
  }
  if ((alpha < 0) | (alpha > 1)) {
    stop("The tuning parameter alpha is not between 0 and 1!")
  }
  if (missing(type)) {
    type <- "consumption"
    warning("No type is given! The SP based on consumption is in use!")
  }

  n <- dim(adjmat)[1]
  type  <- match.arg(type)
  if (type == "consumption") {
    adj <- t(t(adjmat) / gross)
  } else if (type == "distribution") {
    adj <- adjmat / gross
  }
  adj[is.nan(adj)] <- 0
  distance <- as.vector(sapply(1:n, function(k) {dijkstra(-log(adj), k)$distance}))
  prevnode <- as.vector(sapply(1:n, function(k) {dijkstra(-log(adj), k)$prevnode}))
  excl.na <- which(is.na(prevnode) == FALSE)
  distance[excl.na] <- exp(-distance[excl.na])

  allpath <- vector(mode = "list", length = n*n)
  for (i in 1:n) {
    for (j in 1:n) {
      if (is.na(prevnode[(i-1)*n+j]) == FALSE) {
        last_node <- j
        while (is.na(last_node) == FALSE) {
          allpath[[(i-1)*n+j]] <- append(allpath[[(i-1)*n+j]], last_node, 0)
          last_node <- prevnode[(i-1)*n+last_node]
        }
      }
    }
  }

  btw <- numeric(n)
  for (j in 1:(n^2)) {
    path <- allpath[[j]]
    m <- length(path)
    source <- path[1]
    target <- path[m]
    if (m <= 2) {
      next
    }
    if (type == "consumption") {
      for (k in 2:(m-1)) {
        temp <- path[k]
        btw[temp] <- btw[temp] +
          (gross[target]*distance[j])^alpha * prior[source]^(1-alpha)
      }
    } else if (type == "distribution") {
      for (k in 2:(m-1)) {
        temp <- path[k]
        btw[temp] <- btw[temp] +
          (gross[source]*distance[j])^alpha * prior[target]^(1-alpha)
      }
    }
  }

  SP <- matrix(lapply(allpath, function(x) {x[-c(1, length(x))]}), n, n, byrow = TRUE)
  strength <- matrix(distance, n, n, byrow = TRUE)
  if (type == "consumption") {
    str.gross <- t(t(strength) * gross)
  } else if (type == "distribution") {
    str.gross <- strength * gross
  }
  return(list(btw = btw, path = SP, str = strength, str.gross = str.gross))
}

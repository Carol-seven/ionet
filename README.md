
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ionet <img src="man/figures/logo.png" align="right" height="170"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/Carol-seven/ionet/workflows/R-CMD-check/badge.svg)](https://github.com/Carol-seven/ionet/actions)
[![DOI](https://img.shields.io/badge/DOI-10.1016/j.physa.2022.128200-blue.svg)](https://doi.org/10.1016/j.physa.2022.128200)
<!-- badges: end -->

The goal of **ionet** is to develop network functionalities specialized
for the data generated from input-output tables.

## Installation

You can install the development version of **ionet** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Carol-seven/ionet")
```

## Function

`btw()`: betweenness centrality measure that incorporates available
node-specific auxiliary information based on strongest path.

`data_WIOD()`: get data from the World Input-Output Database (WIOD).

`dijkstra()`: implementation of the Dijkstra's algorithm to find the shortest paths
from the source node to all nodes in the given network.

## Data \| Input-Output Tables

| Database                                   | Economies | Years      |Sectors|     Notes     |
|:-------------------------------------------|:---------:|:----------:|:-----:|:-------------:|
| the National Bureau of Statistics of China |   China   |   2002     |  122  |   Built-in    |
|                                            |           |   2005     |  42   |
|                                            |           |   2007     |  135  |
|                                            |           |   2010     |  41   |
|                                            |           |   2012     |  139  |
|                                            |           |   2015     |  42   |
|                                            |           |   2017     |  149  |
|                                            |           |   2017     |  42   |
|                                            |           |   2018     |  153  |
|                                            |           |   2018     |  42   |
|                                            |           |   2020     |  153  |
|                                            |           |   2020     |  42   |
| OECD Input-Output Tables 2021 edition      |   China   | 1995--2018 |  45   |   Built-in    |
| OECD Input-Output Tables 2021 edition      |   Japan   | 1995--2018 |  45   |   Built-in    |
| WIOD 2013 Release                          |  40+RoW   | 1995--2011 |  35   | `data_WIOD()` |
| WIOD 2016 Release                          |  43+RoW   | 2000--2014 |  56   | `data_WIOD()` |
| Long-run WIOD                              |  25+RoW   | 1965--2000 |  23   | `data_WIOD()` |

## Recommended Citation

Xiao, S., Yan, J. and Zhang, P. (2022). Incorporating auxiliary
information in betweenness measure for input-output networks. *Physica
A: Statistical Mechanics and its Applications*, 607, 128200.

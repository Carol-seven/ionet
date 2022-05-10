toymat <- matrix(c(0,5,3,0,0,0,0,
                   0,0,2,0,3,0,1,
                   0,0,0,7,7,0,0,
                   2,0,0,0,0,6,0,
                   0,0,0,2,0,1,0,
                   0,0,0,0,0,0,0,
                   0,0,0,0,1,0,0),
                 7, 7, byrow = TRUE)

test_that("dijkstra() implement Dijkstra's algorithm", {
  expect_equal(
    dijkstra(toymat, 1),
    list("distance" = c(0, 5, 3, 9, 7, 8, 6),
         "prevnode" = c(NA, 1, 1, 5, 7, 5, 2))
  )
})

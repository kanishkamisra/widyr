#' Multidimensional Scaling of documents separated by a distance measure.
#'
#' Given a tbl or data frame of pairwise distances between documents, scale each document
#' to a *k* dimensional space that ensures the distance between all documents is maintained.
#' **NOTE:** Doesnt work when the pairwise distance tbl is formed using \code{upper = FALSE}.
#'
#' @param tbl Table obtained by running a pairwise distance method \code{pairwise_delta} or \code{pairwise_dist}
#' @param item1 first item
#' @param item1 second item
#' @param value Value
#' @param k number of dimensions, defaults to 2
#'
#' @examples
#'
#' library(janeaustenr)
#' library(dplyr)
#' library(tidyr)
#' library(tidytext)
#' library(tibble)
#'
#' # closest documents in terms of 1000 most frequent words
#' austen_delta <- austen_books() %>%
#'   unnest_tokens(word, text) %>%
#'   count(book, word) %>%
#'   pairwise_delta(book, word, n)
#'
#' austen_delta
#'
#' austen_delta %>%
#'   multi_scale(item1, item2, delta)
#'
#' @export

multi_scale <- function(tbl, item1, item2, value, k = 2) {
  multi_scale_(tbl,
               col_name(substitute(item1)),
               col_name(substitute(item2)),
               col_name(substitute(value)),
               k = 2)
}


multi_scale_ <- function(tbl, item1, item2, value, k = 2) {
  tbl_matrix <- tbl %>%
    spread(item2, col_name(value), fill = 0) %>%
    as.data.frame() %>%
    remove_rownames() %>%
    column_to_rownames("item1") %>%
    as.matrix()

  cmdscale(tbl_matrix, k = k) %>%
    as.data.frame() %>%
    rownames_to_column("item") %>%
    as.tibble()
}
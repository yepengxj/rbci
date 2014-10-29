###### Initialize backend processing #######
rbci.env <- new.env()
rbci.env$opts <- list()
rbci.env$importlist <- list()
rbci.env$filterlist <- list()
rbci.env$transformlist <- list()

library(data.table)
library(tools)
library(parallel)
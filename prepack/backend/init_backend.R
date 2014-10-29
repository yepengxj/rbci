###### Initialize backend processing #######
rbci.env <- new.env() # environment for storing GUI state stuff
rbci.env$opts <- list()
rbci.env$importlist <- list()
rbci.env$filterlist <- list()
rbci.env$transformlist <- list()

library(tools)
library(parallel)
library(foreach)

library(R.matlab) # for importing matfiles

library(abind)
library(reshape2)
library(gdata) # for cleanups: keep()
library(data.table)

library(ggplot2)
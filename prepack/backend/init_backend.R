###### Initialize backend processing #######
rbci.env <- new.env() # environment for storing GUI state stuff
rbci.env$opts <- list()
rbci.env$importlist <- list()
## tags for annotation
## hierarchy:
## rbci.env
##  -> tags
##   -> data name
##    -> targetcol
##       valuecol
rbci.env$tags <- list()
rbci.env$taglist <- list(targetcol = NULL, valuecol = NULL)
rbci.env$filterlist <- list()
rbci.env$transformlist <- list()

# gc() # ensure we have a clean slate

library(tools)
library(parallel)
library(foreach)
library(doMC)

library(R.matlab) # for importing matfiles

library(abind)
library(reshape2)
library(gdata) # for cleanups: keep()
library(data.table)

library(ggplot2)

# misc utility functions
source("./backend/misc.R")

# importer backend
source("./backend/importers.R")
# explorer backend
source("./backend/explorers.R")

###### Initialize backend processing #######
rbci.env <- new.env() # environment for storing GUI state stuff
rbci.env$opts <- list()
## list for datasets
### TODO rename 
rbci.env$importlist <- list()
## tags for annotation
## hierarchy:
## rbci.env
##  -> tags
##   -> data name
##    -> targetcol
##       valuecol
rbci.env$tags <- list() 
rbci.env$taglist <- list(targetcol = NULL,
                         valuecol = NULL,
                         epochcol = NULL)

### list for storing steps for later reporting
## hierarchy:
## step
##  -> summary.text string
##  -> code.expr expression
##  -> enabled boolean
rbci.env$steplist <- list()
### TODO revisit these
rbci.env$filterlist <- list()
## list for computed transforms
rbci.env$transformlist <- list()
## list for transformed data
rbci.env$transdatalist <- list()

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

### misc utility functions
source("./backend/misc.R")
### importer backend
source("./backend/importers.R")
### explorer backend
source("./backend/explorers.R")
### transformer backend
source("./backend/transformers.R")
### reporter backend
source("./backend/reporters.R")

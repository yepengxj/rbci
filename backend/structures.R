### initial data structure definitions
rbci.env <- new.env() # environment for storing GUI state stuff
rbci.env$opts <- list()
## list for datasets
### TODO rename 
rbci.env$importlist <- list()
### list for storing steps for later reporting
## hierarchy:
## step
##  -> summary.text string
##  -> code.expr expression
##  -> enabled boolean
rbci.env$steplist <- list()
## example/test table:
# rbci.env$steplist <-
#     list(step1 =
#              list(summary = "transform.pca of set.1",
#                   enabled = TRUE,
#                   code = "transform.pca(set.1,\nsome.params"),
#          step2 =
#              list(summary = "downsample.dt of set.2",
#                   enabled = FALSE,
#                   code = "downsample.dt(set.2)")
#          )

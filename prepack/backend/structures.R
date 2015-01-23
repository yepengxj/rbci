### initial data structure definitions
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
## example/test table:
rbci.env$steplist <-
    list(step1 =
             list(summary = "transform.pca of set.1",
                  enabled = TRUE,
                  code = "transform.pca(set.1,\nsome.params"),
         step2 =
             list(summary = "downsample.dt of set.2",
                  enabled = FALSE,
                  code = "downsample.dt(set.2)")
         )

### TODO revisit these
rbci.env$filterlist <- list()
## list for computed transforms
rbci.env$transformlist <- list()
## list for transformed data
rbci.env$transdatalist <- list()

# gc() # ensure we have a clean slate

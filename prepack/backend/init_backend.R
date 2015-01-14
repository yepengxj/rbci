###### Initialize backend processing #######
### load libs
source("./dependencies.R")

### load data structures
source("./backend/structures.R")

### misc utility functions
source("./backend/misc.R")
### importer backend
source("./backend/importers.R")
### explorer backend
source("./backend/explorers.R")
### filter backend
source("./backend/simple_filter.R")
source("./backend/plot_filter.R")
source("./backend/apply_filter.R")
source("./backend/downsample_dt.R")
### transformer backend
source("./backend/transformers.R")
### classifier backend
source("./backend/classifiers.R")
### reporter backend
source("./backend/reporter.R")

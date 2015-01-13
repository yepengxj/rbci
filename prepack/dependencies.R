### libraries required
## should be consolidated here like a package.json file in node

library(tools)
library(devtools)   # for installing github libs
library(parallel)
library(foreach)    # explicit parallel frontend
library(doMC)       # local multicore backend
library(R.matlab)   # for importing matfiles
library(signal)     # signal processing lib
library(abind)      # multivariate array concatenator
library(R.utils)    
library(reshape2)   # for dcast, melt
library(gdata)      # for cleanups: keep()
library(data.table) # hyperfast memory-efficient data struct
library(ggplot2)    # general plotting engine
library(ggbiplot)   # ggidevtools-dependent
library(JADE)       # joint diagonalization
library(psych)      # geometric, harmonic means
library(cluster)    # clusplot, silhouette

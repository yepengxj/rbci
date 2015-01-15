### libraries required
## should be consolidated here like a package.json file

cran.dependencies = c(
    "tools"     ,  
    "devtools"  ,  # for installing github libs
    "parallel"  ,  # TODO needed?
    "foreach"   ,  # explicit parallel frontend
    "doMC"      ,  # local multicore backend
    "R.matlab"  ,  # for importing matfiles
    "signal"    ,  # signal processing lib
    "abind"     ,  # multivariate array concatenator
    "R.utils"   ,  
    "reshape2"  ,  # for dcast, melt
    "gdata"     ,  # for cleanups: keep""
    "data.table",  # hyperfast memory-efficient data struct
    "ggplot2"   ,  # general plotting engine
    "JADE"      ,  # joint diagonalization
    "psych"     ,  # geometric, harmonic means
    "cluster"   ,  # clusplot, silhouette
    "sda"       ,  # sda classifier
    "LiblineaR"    # linear svm classifier    
    )

github.dependencies = list(
    ggbiplot = "vqv/ggbiplot"  # ggidevtools-dependent
    )

## install and load missing dependencies
lapply(cran.dependencies, function(x) {
    if (!(require(x, character.only = TRUE))) {
        install.packages(x)
    }
    
    library(x, character.only = TRUE)
})

lapply(github.dependencies, function(x) {
    if (!(require(x, character.only = TRUE))) {
        install_github(x)
    }

    package.basename <- eval.parent(quote(names(X)))[substitute(x)[[3]]]
    ## print(package.basename)
    library(package.basename,
            character.only = TRUE)
})

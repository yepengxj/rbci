### libraries required
## should be consolidated here like a package.json file in node

cran.dependencies = c(
    "gWidgets"      ,  # GUI framework
    "gWidgetsRGtk2" ,  # bindings for GTK2
    "tools"         ,  
    "devtools"      ,  # for installing github libs
    "parallel"      ,  # TODO needed?
    "foreach"       ,  # explicit parallel frontend
    "doMC"          ,  # local multicore backend
    "doSNOW"        ,  # SNOW cluster backend
    "doMPI"         ,  # MPI cluster backend
    "doRedis"       ,  # Redis job store backend
    "R.matlab"      ,  # for importing matfiles
    "signal"        ,  # signal processing lib
    "abind"         ,  # multivariate array concatenator
    "R.utils"       ,  
    "reshape2"      ,  # for dcast, melt
    "gdata"         ,  # for cleanups: keep""
    "data.table"    ,  # hyperfast memory-efficient data struct
    "ggplot2"       ,  # general plotting engine
    "JADE"          ,  # joint diagonalization
    "psych"         ,  # geometric, harmonic means
    "cluster"       ,  # clusplot, silhouette
    "sda"           ,  # sda classifier
    "LiblineaR"     ,  # linear svm classifier
    "kernlab"       ,  # kernel pca/svm lib
    "e1071"         ,  # naiveBayes classifier
    "knitr"            # report generator
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
    package.basename <- eval.parent(quote(names(X)))[substitute(x)[[3]]]
    
    if (!(require(package.basename, character.only = TRUE))) {
        install_github(x)
    }
    
    ## print(package.basename)
    library(package.basename,
            character.only = TRUE)
})

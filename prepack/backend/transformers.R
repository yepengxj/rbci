rbci.env$pcaopts <- list()
library(kernlab) # nonlinear PCA

transform.pca <- function(targ.name = "Class",
                          epoch.name = "Trial",
                          time.name = "Time",
                          eeg.table,
                          kernel.type,
                          pc.count = 2,
                          scale.data = FALSE,
                          pca.opts,
                          pca.tol = sqrt(.Machine$double.eps)) {

    if (kernel.type == "Linear") {
        eeg.pca <- prcomp(reformulate(termlabels =
                                          setdiff(colnames(eeg.table),
                                                  c(targ.name,
                                                    epoch.name,
                                                    time.name))),
                          data = eeg.table,
                          scale = scale.data,
                          tol = pca.tol)
        
        ## pull the pieces we need from each object into standard list?
        ## for now, since it's not very big, let's just keep what we get
        return(eeg.pca)
    }
    else {
        ## nonlinear case
        switch(kernel.type,
               Gaussian = {
                                        # options: sigma
                   eeg.pca <- kpca(as.formula(paste("~ .",
                                                    "-",targ.name,
                                                    "-",epoch.name,
                                                    "-",time.name)),
                                   data = eeg.table,
                                   kernel = "rbfdot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma),
                                   features = pc.count, th = pca.tol)
               },
               Laplace = {
                                        # options: sigma
                   eeg.pca <- kpca(as.formula(paste("~ .",
                                                    "-",targ.name,
                                                    "-",epoch.name,
                                                    "-",time.name)),
                                   data = eeg.table,
                                   kernel = "laplacedot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma),
                                   features = pc.count, th = pca.tol)
               },
               Polynomial = {
                                        # options: degree, scale, offset
                   eeg.pca <- kpca(as.formula(paste("~ .",
                                                    "-",targ.name,
                                                    "-",epoch.name,
                                                    "-",time.name)),
                                   data = eeg.table,
                                   kernel = "polydot",
                                   kpar = list(degree = rbci.env$pcaopts$degree,
                                               scale = rbci.env$pcaopts$scale,
                                               offset = rbci.env$pcaopts$offset),
                                   features = pc.count, th = pca.tol)
               },
               Hyperbolic = {
                                        # options: scale, offset
                   eeg.pca <- kpca(as.formula(paste("~ .",
                                                    "-",targ.name,
                                                    "-",epoch.name,
                                                    "-",time.name)),
                                   data = eeg.table,
                                   kernel = "tanhdot",
                                   kpar = list(scale = rbci.env$pcaopts$scale,
                                               offset = rbci.env$pcaopts$offset),
                                   features = pc.count, th = pca.tol)
               },
               Bessel = {
                                        # options: sigma, order, degree
                   eeg.pca <- kpca(as.formula(paste("~ .",
                                                    "-",targ.name,
                                                    "-",epoch.name,
                                                    "-",time.name)),
                                   data = eeg.table,
                                   kernel = "besseldot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma,
                                               order = rbci.env$pcaopts$order,
                                               degree = rbci.env$pcaopts$degree),
                                   features = pc.count, th = pca.tol)
               },
               ANOVA = {
                                        # options: sigma, degree
                   eeg.pca <- kpca(as.formula(paste("~ .",
                                                    "-",targ.name,
                                                    "-",epoch.name,
                                                    "-",time.name)),
                                   data = eeg.table,
                                   kernel = "laplacedot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma,
                                               degree = rbci.env$pcaopts$degree),
                                   features = pc.count, th = pca.tol)
               })
        
    }
}

transform.kmeans <- function(kmeans.data,
                             val.col,
                             kmeans.type,
                             centers,
                             max.iters,
                             groups) {
### wrapper function for kmeans functions, for easy extension
    
    kmeans(kmeans.data[,get(val.col)], centers, max.iters,
           algorithm = kmeans.type)

}

transform.csp <- function(table.data, time.col, chan.col, val.col, trial.col,
                          class.col, avg.type) {
    
    ## compute correlation matrices by trial, class
    setkeyv(table.data,class.col)
    correlation.mats.list <- foreach(table.data[,unique(get(class.col))]) %do% {
                                        # this loop is deliberately serial:
                                        # not worth trying to parallelize in
                                        # most cases
        acorr.table(table.data,
                    time.col, chan.col, val.col, trial.col)
    }
                                    
    ## average matrices by class
    avg.corr.mats <- lapply(correlation.mats.list, function(x) {
        ## each of these inputs is a cube of matrices
        ## we want to average over the 3rd dimension
        apply(x,c(1,2),mean) # just like that
    })
    
    ## jointly diagonalize
    require(JADE) # Cardoso et. al's diagonalization algorithms
    ## make list of eigenvectors/eigenvalues, return
    rjd(abind3curry(avg.corr.mats))
}

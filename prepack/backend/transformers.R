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
    
        eeg.pca <- prcomp(as.formula(paste("~ .",
                                           "-",targ.name,
                                           "-",epoch.name,
                                           "-",time.name)),
                          data = eeg.table,
                          scale = scale.data,
                          tol = pca.tol)

        ## pull the pieces we need from each object into standard list
    }
    else {
        ## nonlinear case
        switch(kernel.type,
               Gaussian = {
                                        # options: sigma
                   eeg.pca <- kpca(eeg.table, kernel = "rbfdot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma),
                                   features = pc.count, th = pca.tol)
               },
               Laplace = {
                                        # options: sigma
                   eeg.pca <- kpca(eeg.table, kernel = "laplacedot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma),
                                   features = pc.count, th = pca.tol)
               },
               Polynomial = {
                                        # options: degree, scale, offset
                   eeg.pca <- kpca(eeg.table, kernel = "polydot",
                                   kpar = list(degree = rbci.env$pcaopts$degree,
                                               scale = rbci.env$pcaopts$scale,
                                               offset = rbci.env$pcaopts$offset),
                                   features = pc.count, th = pca.tol)
               },
               Hyperbolic = {
                                        # options: scale, offset
                   eeg.pca <- kpca(eeg.table, kernel = "tanhdot",
                                   kpar = list(scale = rbci.env$pcaopts$scale,
                                               offset = rbci.env$pcaopts$offset),
                                   features = pc.count, th = pca.tol)
               },
               Bessel = {
                                        # options: sigma, order, degree
                   eeg.pca <- kpca(eeg.table, kernel = "besseldot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma,
                                               order = rbci.env$pcaopts$order,
                                               degree = rbci.env$pcaopts$degree),
                                   features = pc.count, th = pca.tol)
               },
               ANOVA = {
                                        # options: sigma, degree
                   eeg.pca <- kpca(eeg.table, kernel = "laplacedot",
                                   kpar = list(sigma = rbci.env$pcaopts$sigma,
                                               degree = rbci.env$pcaopts$degree),
                                   features = pc.count, th = pca.tol)
               })

        ## pull the pieces we need from the resulting object into standard list
    }

    ## return list object we created
}

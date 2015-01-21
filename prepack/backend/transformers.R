rbci.env$pcaopts <- list()
library(kernlab) # nonlinear PCA

transform.pca <- function(targ.name = "Class",
                          epoch.name = "Trial",
                          time.name = "Time",
                          split.col = "Channel",
                          val.col = "Voltage",
                          input.table,
                          kernel.type,
                          pc.count = 2,
                          scale.data = FALSE,
                          pca.opts, # TODO needed?
                          pca.tol = sqrt(.Machine$double.eps)) {

    ## break out to channels for PCA function
    eeg.table <- channel.form(input.table,
                              value.col = val.col,
                              split.col = split.col,
                              class.col = targ.name,
                              time.col = time.name,
                              trial.col = epoch.name,
                              has.dups = FALSE)
    
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

transform.pc <- function(pca.model,
                         targ.name = "Class",
                         epoch.name = "Trial",
                         time.name = "Time",
                         split.col = "Channel",
                         val.col = "Voltage",
                         long.data.set) {
### TODO error checking on input
    
    ## convert long.data.set to wide form
    eeg.table <- channel.form(long.data.set,
                              value.col = val.col,
                              split.col = split.col,
                              class.col = targ.name,
                              time.col = time.name,
                              trial.col = epoch.name,
                              has.dups = FALSE)
    
    ## do PCA prediction
    pca.pred <- as.data.table(predict(pca.model, newdata = eeg.table))
    pca.pred[, targ.name := eeg.table[,get(targ.name)], with = FALSE]
    pca.pred[, epoch.name := eeg.table[,get(epoch.name)], with = FALSE]
    pca.pred[, targ.name := as.factor(get(targ.name)), with = FALSE]

    return(pca.pred)
}

transform.kmeans <- function(kmeans.data,
                             val.col,
                             kmeans.type,
                             centers,
                             max.iters) {
##                             groups) {
### wrapper function for kmeans functions, for easy extension
    
    kmeans(kmeans.data[,get(val.col)], centers, max.iters,
           algorithm = kmeans.type)

}

transform.csp <- function(table.data,
                          time.col, chan.col,
                          val.col, trial.col,
                          class.col,
                          avg.type = "Arithmetic",
                          pair.count = 2) {

    ## convert to wide channel form
    ## returns a table with cols Class, Sample, Trial, Ch1, Ch2..
    table.channel <- channel.form(table.data,
                                  value.col = val.col,
                                  split.col = chan.col,
                                  class.col = class.col,
                                  time.col = time.col,
                                  trial.col = trial.col,
                                  has.dups = FALSE)
    
    num.channels <- length(names(table.channel))-3
    if (pair.count == 0) { # all columns case
        pair.count = num.channels/2
        ### TODO fit odd channels
    }

    ## construct vector pairing (first, last, etc.)
    pair.vec <- c((num.channels+1)-seq_len(pair.count),
                  seq_len(pair.count))
    
    ## compute correlation matrices by trial, class
    setkeyv(table.data,class.col)
    setkeyv(table.channel,class.col) ### TODO review this
    ## build map of trials/classes
    class.trial.map <- lapply(table.channel[,unique(get(class.col))], 
                              function(x){
                                  table.channel[J(x),unique(get(trial.col))]
                              })
    correlation.mats.list <- # a list of lists; class( trial(...
        lapply(class.trial.map, function(class.trials) { # dumb hybrid approach?
            foreach (this.trial = class.trials, 
                     .combine = abind3curry) %do% {
                         
                         cor(table.channel[get(trial.col) == this.trial,
### TODO fix these magic numbers (we're selecting the chan vars only)
                                           names(table.channel)[4:length(names(table.channel))],
                                           with=FALSE]
                             )
                     }
        })
            
    ## str(correlation.mats.list)
    ## average matrices by class
    avg.corr.mats <- lapply(correlation.mats.list, function(x) {
        ## each of these inputs is a cube of matrices
        ## we want to average over the 3rd dimension
        switch(avg.type,
               "Arithmetic" = {
                   apply(x,c(1,2),mean) # just like that
               },
               "Geometric" = {
                   apply(x,c(1,2),geometric.mean)
               },
               "Harmonic" = {
                   apply(x,c(1,2),harmonic.mean)
               })
    })

    ## jointly diagonalize
    ## make list of eigenvectors/eigenvalues, return
    lapply(rjd(abind3curry(avg.corr.mats)), function(x) {
        ## return only as many pairs as required by input        
        extract(x, indices=list("2"=pair.vec))
    })
}

transform.cs <- function(csp.model,
                         targ.name,
                         epoch.name,
                         time.name,
                         split.col,
                         val.col,
                         long.data.set) {
### TODO error checking on input
    
    
}

##### converting from long table form to channel-split wide form #####
## for multivariate repeated time series
channel.form <- function(input.table,
                         value.col = "Voltage",
                         split.col = "Channel",
                         class.col = "Class",
                         time.col = "Time",
                         trial.col = "Trial",
                         has.dups = FALSE) { # TODO has.dups needed?
    # Converts long table format to slightly wider format split by channels.
    # For epoched datasets.
    
    # add id col if there are duplicates, replace trial column
    if (has.dups == TRUE) {
        input.table[,c(trial.col):= sample.int(nrow(input.table))]
        setkeyv(input.table,trial.col)
        #trial.col = "id"
    }
    setkeyv(input.table, class.col)

    ## magic begins here...
    chan.split <- split(input.table,input.table[,get(split.col)])
    chan.table <- cbind(lapply(chan.split,
                           function(x){
                               x[,value.col,with=FALSE]
                           }))
    
    chan.table <-
        as.data.table(matrix(unlist(chan.table),
                             ncol = input.table[,length(unique(get(split.col)))],
                             byrow=TRUE))
    ## reintroduce class labels
    # since the split is over identical sections for each channel, we can just
    # use the first split's labels
    chan.table <- chan.table[,c(class.col):= chan.split[[1]][,get(class.col)]]
    chan.table[,c(class.col):=as.factor(get(class.col))]
    # similarly with time and trial labels
    chan.table <- chan.table[,Time:= chan.split[[1]][,get(time.col)]]
    chan.table <- chan.table[,Trial:= chan.split[[1]][,get(trial.col)]]

    setnames(chan.table,old=names(chan.table),
             new=c(paste("Ch",input.table[,unique(get(split.col))],sep=""),
                 class.col,time.col,trial.col))
    
    # data.table is not picky about column order, but we need to be in case of
    # coercion to matrices etc.
    setcolorder(chan.table,
              c(class.col,time.col,trial.col,
                paste("Ch",sort(input.table[,unique(get(split.col))]),sep="")))
    
    return(chan.table)
}


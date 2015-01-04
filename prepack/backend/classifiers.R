### SVM functions

train.svm.model <- function(train.data,
                            kern.type,
                            target.col,
                            feature.cols,
                            cost.param,
                            kern.params = list(),
                            ...) {
    
    if (kern.type == "Linear") {
        ## use LiblineaR
        ## assume uniform prior for now
        class.labels <- train.data[,levels(target.col)]
        weights <- rep(1, times = length(class.labels))/length(class.labels)
        setNames(weights, c(class.labels))

        svm.model <-
            LiblineaR(wi = weights,
                      cost = cost.param,
                      type = 3,
                      data = train.data[,feature.cols,with=FALSE],
                      labels = train.data[,get(target.col)])
        
    } else {
        ## use kernlab
        ## map kernel types to param strings
        switch(kern.type,
               "Laplace"={ kern.type <- "laplacedot" },
               "Gaussian"={ kern.type <- "rbfdot" },
               "Polynomial"={ kern.type <- "polydot" },
               "Hyperbolic"={ kern.type <- "tanhdot" },
               "Bessel"={ kern.type <- "besseldot" },
               "ANOVA RBF"={ kern.type <- "anovadot" },
               "Spline"={ kern.type <- "splinedot" }
               )
        
        ## make params list
        ## param.list <- 
            
            
        svm.model <-
            ksvm(data = train.data,
                 kernel = kern.type,
                 C = cost.param,
                 kpar = kern.params,
                 x = as.formula(paste(target.col,"~", feature.cols)))
        
    }
}

test.svm.model <- function(test.data, svm.model, ...) {
    ## all decent SVM packages overload predict(), but just in case this is for
    ## portability
    predict(svm.model,
            test.data)
    
}

plot.svm.model <- function(svm.model, ...) {
    ## LiblineaR doesn't have a plot method, so check the model type
    if (class(svm.model) == "LiblineaR") {
### TODO make this more consistent
        return(NULL)
    }
    
    return(plot(svm.model))
}

table.svm.model <- function(svm.prediction, test.data) {
    switch(class(svm.prediction),
           "list"={ # predict.LiblineaR() returns a list
               table(svm.prediction$predictions,test.data)
           },
           "matrix"={ # predict.ksvm() returns a matrix
               table(svm.prediction,test.data)
           })
}

### SDA functions
train.sda.model <- function(train.data,
                            target.col,
                            feature.cols,
                            sda.lambda,
                            sda.lambda.var) {

    sda.model <-
        sda(lambda.freqs = 1, # uniform prior
            as.matrix(train.data[,feature.cols,with=FALSE]),
            train.data[,get(target.col)],
            lambda = sda.lambda,
            lambda.var = sda.lambda.var)

}

test.sda.model <- function(sda.model, test.data) {
    predict(sda.model, test.data)
}

### TODO sda does not have a native plot function

table.sda.model <- function(sda.prediction, test.data) {

    table(predicted = sda.prediction$class,
          data = test.data)

}

### Bayes functions

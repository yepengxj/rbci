### SVM functions

train.svm.model <- function(train.data,
                            kern.type,
                            target.col,
                            feature.cols,
                            cost.param,
                            kern.params = list(),
                            ...) {

    ## sanitize params
    cost.param <- if(is.na(as.numeric(cost.param)) ||
                     !(as.numeric(cost.param) > 0)) 1 else cost.param # R standard elvis op

    if (kern.type == "Linear") {
        ## use LiblineaR
        ## assume uniform prior for now
        class.labels <- train.data[, levels(factor(get(target.col)))]
        weights <- rep(1, times = length(class.labels))/length(class.labels)
        weights <- setNames(weights, c(class.labels))

        svm.model <-
            LiblineaR(wi = weights,
                      cost = cost.param,
                      type = 3, # TODO comment this
                      data = train.data[, feature.cols, with=FALSE],
                      labels = train.data[,factor(get(target.col))])
        
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
    return(svm.model)
}

test.svm.model <- function(test.data, svm.model, feature.cols) {
    ## all decent SVM packages overload predict(), but just in case this is for
    ## portability

    predict(svm.model,
            test.data[,feature.cols, with = FALSE])
    
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
            as.matrix(train.data[, c(feature.cols), with = FALSE]),
            train.data[,get(target.col)],
            lambda = sda.lambda,
            lambda.var = sda.lambda.var)
    
}

test.sda.model <- function(sda.model, test.data, feature.cols) {
### TODO error checking on input
    
    predict(sda.model, as.matrix(test.data[, feature.cols, with=FALSE]))
}

### TODO sda does not have a native plot function

table.sda.model <- function(sda.prediction, test.data) {

    table(predicted = sda.prediction$class,
          data = test.data)

}

### Bayes functions

train.bayes.model <- function(train.data,
                              bayes.smooth,
                              target.col,
                              feature.cols) {

    ## validate target as factor type
    train.data[,c(target.col) := factor(get(target.col))]
    bayes.model <-
        naiveBayes(formula = as.formula(paste(target.col,"~", feature.cols)),
                   data = train.data,
                   laplace = bayes.smooth)
    
    
}

test.bayes.model <- function(bayes.model, test.data) {

    bayes.pred <- list(prediction = predict(bayes.model, test.data))
    return(bayes.pred)
}

### TODO bayes does not have a native plot function

table.bayes.model <- function(bayes.prediction, test.data) {
    
    table(bayes.prediction$prediction, test.data)
    
}

### SVM functions

train.svm.model <- function(train.data,
                            kern.type, ...) {
    if (kern.type == "Linear") {
        ## use LiblineaR
        
    } else {
        ## use kernlab
        
    }
}

test.svm.model <- function(test.data, svm.model, ...) {
    ## all decent SVM packages overload predict()
    
}

plot.svm.model <- function(svm.model, ...) {
    
}

table.svm.model <- function(svm.model, ...) {

}

### SDA functions


### Bayes functions

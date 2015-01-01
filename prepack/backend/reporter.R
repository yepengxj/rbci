tabulate.steplist <- function(steplist) {
### converts steplist to table form for GUI interaction
### (once done, the report generator also has to use this form, but it's only
### done once)

    if (!is.null(steplist)) {
        t(sapply(steplist,unlist))
    } else {
        ## return a dummy df that matches structure
        return(t(as.matrix(list(summary.text=NULL,code=NULL,enabled=FALSE))))
    }

}

### TODO fixme
toggle.row <- function(steplist.table, row.ind) {
### toggles enabled.col of steplist.table
    steplist.table[row.ind,]$enabled <- !steplist.table[row.ind,]$enabled
    
}

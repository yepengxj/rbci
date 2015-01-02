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

toggle.row <- function(steplist.table, row.ind) {
### toggles enabled.col of steplist.table
    steplist.table[row.ind,]$enabled <-
        !as.logical(steplist.table[row.ind,'enabled'])
    
}

build.report <- function(steplist.table, report.title, report.author,
                         output.dir) {
    
    ## collect up a a list of code objects that need to be run to be passed out
    step.list <- steplist.table[steplist.table$enabled,]
    
    ## get an R Markdown file ready
    file.name <- paste(output.dir, strsplit(report.title, " ")[[1]][1],
                      sep = "/") 
    file.create(file.name)

    file.conn <- file(file.name, open = "a")
    ## write header junk like title and author
    writeLines(make.report.head(report.title,report.author), file.conn)
    
    lapply(step.list, function(this.step) {
        ## write summary
        ## write RMarkdown delimiters and code
        writeLines(c(this.step$summary,"```",this.step$code,"```"))
        
    })
    
    ## call knitr on resulting Rmd file
}

make.report.head <- function(report.title, report.author) {
### convenience function for generating a decent rmarkdown header
}

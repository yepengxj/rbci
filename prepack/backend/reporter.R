tabulate.steplist <- function(steplist) {
### converts steplist to table form for GUI interaction
### (once done, the report generator also has to use this form, but it's only
### done once)

    if (!is.null(steplist)) {
        t(sapply(steplist,unlist))
    } else {
        ## return a dummy df that matches structure
### TODO revisit this
        return(t(as.matrix(list(summary.text=NULL, code=NULL, enabled=FALSE))))
    }

}

toggle.row <- function(steplist.table, row.ind) {
### toggles enabled.col of steplist.table
    steplist.table[row.ind,]$enabled <-
        !as.logical(steplist.table[row.ind,'enabled'])
    
}

export.single.step <- function(some.code) {
### evaluates a single step of code as stored by the reporter;
### expects a string
    
    ## run given code, capture output
    code.result <- capture.output({
        eval(parse(some.code))
    })

}

build.report <- function(steplist.table, report.title, report.author,
                         output.dir) {
    
    ## collect up a a list of code objects that need to be run to be passed out
    step.list <- steplist.table[steplist.table$enabled,]
    
    ## get an R Markdown file ready
    file.name <- paste(output.dir, "/", strsplit(report.title, " ")[[1]][1],
                       ".Rmd", # needed?
                       sep = "")
    file.create(file.name)
    
    file.conn <- file(file.name, open = "a")
    ## write header junk like title and author
    writeLines(make.report.head(report.title,report.author), file.conn)
    
    lapply(step.list, function(this.step) {
        ## write summary
        ## write RMarkdown delimiters and code
        writeLines(c(this.step$summary,"```",this.step$code,"```"))
        
    })
    close(file.conn)
    
    ## call knitr on resulting Rmd file
    ## do some directory finagling to make sure knitr is happy
    cur.dir <- getwd()
    setwd(output.dir)
    knit2html(basename(file.name))
    if (interactive()) browseURL(paste(file_path_sans_ext(basename(file.name))))
    setwd(cur.dir) # undo dir finagle
}

make.report.head <- function(report.title, report.author) {
### convenience function for generating a decent rmarkdown header
### TODO add settings
    
    c(paste(report.title,"\n","======","\n",sep=""),
      paste("## ",report.author,"\n",sep=""),
      paste("*",Sys.time(),"*",sep=""))
    
}

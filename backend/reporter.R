add.step <- function(func.name, step.args) {
### adds called analysis steps and their args to the reporter view.
### Should be called by every analysis GUI button.

    ## a short summary for the user
    ### TODO first arg of all main analysis functions should be the dataset
    ## abbreviate the first argument call to 50 chars in case it's huge
    main.arg.short <- substr(as.character(step.args[1]), 1, 50)
    step.summary <- paste(func.name, "of", main.arg.short)

### we assume arguments are explicitly named for all functions of this kind
### see https://github.com/talexand/rbci/issues/55 for discussion

    new.step <- list(summary = step.summary,
                     enabled = FALSE,
                     code = paste(deparse(
                         bquote(do.call(.(func.name), .(step.args))),
                                        # ensure we get knittable code
                         control = c("showAttributes" = NULL)),
                         collapse = "\n")
                     )

    rbci.env$steplist <- append(rbci.env$steplist,
                                list(new.step))
    
}

tabulate.steplist <- function(steplist) {
### converts steplist to table form for GUI interaction
### (once done, the report generator also has to use this form, but it's only
### done once)

    if (length(steplist) > 0) {
        t(sapply(steplist,unlist))
    } else {
        ## return a dummy df that matches structure
### TODO revisit this
        return(t(as.matrix(list(summary.text="", code="", enabled=""))))
    }
}

toggle.row <- function(steplist.table, row.ind) {
### toggles enabled.col of steplist.table
    steplist.table[row.ind,]$enabled <-
        !as.logical(steplist.table[row.ind,'enabled'])
    
}

build.report <- function(steplist.table, report.title, report.author,
                         output.dir, knit.now = FALSE) {

    ## sanitize output.dir (gWidgets gives single quotes, against convention?)
    output.dir <- gsub("'","", output.dir)
    
    ## collect up a frame of code objects that need to be run to be passed out
    step.list <- as.data.frame(
        steplist.table[which(steplist.table[,'enabled'] == TRUE),]
        )
    ## validation: fail if no steps enabled
    if (nrow(step.list) == 0) { return("no steps to run") }
    
    ## save environment to data directory
    env.file.path <-
        paste(output.dir, "/", strsplit(report.title, " ")[[1]][1],
              ".RData", # needed?
              sep = "")
    save(rbci.env,
         file = env.file.path)
    ## make relative name for portability
    env.file.name <- paste('"',"./", strsplit(report.title, " ")[[1]][1],
                           ".RData", '"',
                           sep = "")
    ## copy backend files to data directory
### TODO make this more portable/track package changes
    dir.create(paste(output.dir, "/backend", sep = ""), mode = "0775")
    file.copy(from = "./backend",
              to = paste(output.dir, "/", sep = ""),
              recursive = TRUE)
    
    ## get an R Markdown file ready
    file.name <- paste(output.dir, "/", strsplit(report.title, " ")[[1]][1],
                       ".Rmd", # needed?
                       sep = "")
    file.create(file.name)
    
    file.conn <- file(file.name, open = "a")

    ## write header junk like title and author
    writeLines(make.report.head(report.title, report.author), file.conn)

    ## write environment+backend load line
    writeLines(c('```{r, results="hide", message=FALSE}',
                 'source("./backend/dependencies.R")', 
                 'sourceDirectory("./backend")',
                 paste("load(",env.file.name,", envir = .GlobalEnv)"),
                 "```", ""),
               file.conn)

    apply(step.list, 1, function(this.step) { # go down by rows (of the df)
        ## write summary
        writeLines(c("", this.step['summary'],
                     "```{r}", # write RMarkdown delimiters and code
                     this.step['code'],
                     "```", ""),
                   con = file.conn)

    })
    close(file.conn)
    
    ## call knitr on resulting Rmd file if enabled
    if (knit.now == TRUE) {
        
        ## do some directory finagling to make sure knitr is happy
        cur.dir <- getwd()
        setwd(output.dir)
        
        knit2html(basename(file.name))
        
        setwd(cur.dir) # undo dir finagle

        if (interactive()) {
            browseURL(paste("file://",file_path_sans_ext(file.name),".html",
                            sep = ""))
        }
    }
}

make.report.head <- function(report.title, report.author) {
### convenience function for generating a decent rmarkdown header
### TODO add settings
### TODO add backend function importer (for now import all funcs; show=false)
    
    c(paste(report.title,"\n","======","\n", sep=""),
      paste("## ",report.author,"\n", sep=""),
      paste("*",Sys.time(),"*","\n", sep=""))
    
}

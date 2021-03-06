csv_tab <- ggroup(container = import_tabs,
                  horizontal = FALSE,
                  label = "CSV/Text")

csv_pane <- gpanedgroup(horizontal = TRUE,
                           expand = TRUE,
                           fill = TRUE,
                           container = csv_tab)

csv_file_frame <- gframe(text = "File path",
                            horizontal = FALSE,
                            container = csv_pane)
#width = window.width/2)

csv_file_button <- gfilebrowse(text = "",
                                  container = csv_file_frame,
                                  quote = FALSE)
addHandlerChanged(csv_file_button,
                  handler=function(h,...) {
                    rbci.env$previewfile <- svalue(csv_file_button)
                  })

csv_preview_button <- 
  gbutton(text = "Preview",
          container = csv_file_frame,
          handler   = function(h, ...) {
            rbci.env$importfile <- read.table(rbci.env$previewfile,
                                           nrows = preview.rowlen)
            ## TODO add CSV formatting options to GUI
            ## delete previous preview frame if present
            if ("csv_preview_frame" %in% ls()) {
              delete(csv_pane, csv_preview_frame)
            }
            ## react to preview type setting
            switch(svalue(csv_preview_type),
                   Columnar = {
                     ## init tabular preview frame
                     csv_preview_frame <<- 
                       gtable(items = 
                                  as.data.frame(
                                  rbci.env$importfile)[seq_len(preview.rowlen),],
                              container = csv_pane)
                     
                     ## column selectors
                     if(exists("csv_column_sel")) {
                         csv_column_sel[] <- # replace members if exists already
                             colnames(as.data.frame(rbci.env$importfile))
                     } else {
                         csv_column_sel <-
                             gcheckboxgroup( # create if new
                                 colnames(as.data.frame(rbci.env$importfile)),
                                 container = csv_option_group,
                                 use.table = TRUE,
                                 expand = TRUE)
                     }
                   },
                   Structural = {
                     csv_preview_frame <<- 
                       gtext(text = paste(capture.output(str(
                         rbci.env$importfile)),"\n"),
                         container = csv_pane,
                         font.attr=c(family="monospace"))
                   },
                   Raw = {
                     csv_preview_frame <<-
                       gtext(text = paste(capture.output(
                         print(sapply(rbci.env$importfile,head,n=2))),"\n"),
                         container = csv_pane,
                         font.attr=c(family="monospace"))
                   })
          })

csv_preview_optframe <- gframe(text = "Preview Type",
                                  container = csv_file_frame,
                                  horizontal = TRUE,
                                  expand = FALSE)
csv_preview_type <- gdroplist(items = c("Columnar","Structural","Raw"),
                                 container = csv_preview_optframe,
                                 fill = "x",
                                 expand = TRUE)
csv_preview_rownum <- gspinbutton(from = 0, to = 20, by = 1,
                                     container = csv_preview_optframe)

csv_option_frame <- gframe(text = "Import Columns",
                              horizontal = FALSE,
                              container = csv_file_frame,
                              expand = TRUE)
csv_option_group <- ggroup(use.scrollwindow = TRUE,
                              horizontal = FALSE,
                              expand = TRUE, 
                              container=csv_option_frame)

csv_export_frame <- gframe(text = "Export/Load",
                              horizontal = TRUE,
                              expand = FALSE,
                              container = csv_file_frame)

csv_export_button <- gbutton(text = "Export to R Data",
                                type = "save",
                                container = csv_export_frame,
                                handler = function(h,...) {
                                  # save file
                                  # get enabled columns
                                  colsel <- sapply(rbci.env$columnboxes,svalue)
                                  
                                  # read full-length file
                                  rbci.env$importfile <- 
                                    read.table(rbci.env$previewfile)
                                  
                                  eegdata <- as.data.table(as.data.frame(
                                    rbci.env$importfile)[,which(colsel==TRUE)])
                                  
                                  save(eegdata,
                                       file = gfile(
                                         filter = list("R Data (RData)"= list(patterns = c("*.RData"))),
                                         type = "save"))
                                })

csv_load_button <- 
  gbutton(text = "Import into interface",
          container = csv_export_frame,
          handler = function(h,...) {
            # rename, insert into interface
            
            # get enabled columns
            colsel <- sapply(rbci.env$columnboxes,svalue)
            
            # read full-length file
            rbci.env$importfile <- 
              read.table(rbci.env$previewfile)
            
            # add imported data to list
            rbci.env$importlist[[
              basename(file_path_sans_ext(svalue(csv_file_button)))]] <-
              as.data.table(as.data.frame(
                rbci.env$importfile)[,which(colsel==TRUE)])
            # in case of duplicates, mark explicitly
            names(rbci.env$importlist) <- 
              make.unique(names(rbci.env$importlist))
            
            # TODO cleanup importfile
            
            galert("Import succeeded.",
                   title = "Status",
                   delay = 2)
          })

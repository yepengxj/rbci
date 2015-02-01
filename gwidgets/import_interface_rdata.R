rdata_tab <- ggroup(container = import_tabs,
                  horizontal = FALSE,
                  label = "R Data")

rdata_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = rdata_tab)

rdata_file_frame <- gframe(text = "File path",
                         horizontal = FALSE,
                         container = rdata_pane)
#width = window.width/2)

rdata_file_button <- gfilebrowse(text = "",
                               container = rdata_file_frame,
                               quote = FALSE)
addHandlerChanged(rdata_file_button,
                  handler=function(h,...) {
                    rbci.env$previewfile <- svalue(rdata_file_button)
                  })

rdata_preview_button <- 
  gbutton(text = "Preview",
          container = rdata_file_frame,
          handler   = function(h, ...) {
            rbci.env$importfile <- load_obj(rbci.env$previewfile)
                                            # nrows = preview.rowlen)
            ## TODO add rdata formatting options to GUI
            # delete previous preview frame if present
            if ("rdata_preview_frame" %in% ls()) {
              delete(rdata_pane, rdata_preview_frame)
            }
            ## react to preview type setting
            switch(svalue(rdata_preview_type),
                   Columnar = {
                     # init tabular preview frame
                     rdata_preview_frame <<- 
                       gtable(items = 
                                as.data.frame(
                                    rbci.env$importfile)[seq_len(preview.rowlen),],
                              container = rdata_pane)
                     
                     ## column selectors
                     if(exists("rdata_column_sel")) {
                         rdata_column_sel[] <- # replace members if exists
                             colnames(as.data.frame(rbci.env$importfile))
                     } else {
                         rdata_column_sel <<- # global assign to resolve scope
                             gcheckboxgroup( # create if new
                                 colnames(as.data.frame(rbci.env$importfile)),
                                 container = rdata_option_group,
                                 use.table = TRUE,
                                 expand = TRUE)
                     }                    
                   },
                   Structural = {
                     rdata_preview_frame <<- 
                       gtext(text = paste(capture.output(str(
                         rbci.env$importfile)),"\n"),
                         container = rdata_pane,
                         font.attr=c(family="monospace"))
                   },
                   Raw = {
                     rdata_preview_frame <<-
                       gtext(text = paste(capture.output(
                         print(sapply(rbci.env$importfile,head,n=2))),"\n"),
                         container = rdata_pane,
                         font.attr=c(family="monospace"))
                   })
          })

rdata_preview_optframe <- gframe(text = "Preview Type",
                               container = rdata_file_frame,
                               horizontal = TRUE,
                               expand = FALSE)
rdata_preview_type <- gdroplist(items = c("Columnar","Structural","Raw"),
                              container = rdata_preview_optframe,
                              fill = "x",
                              expand = TRUE)
rdata_preview_rownum <- gspinbutton(from = 0, to = 20, by = 1,
                                  container = rdata_preview_optframe)

rdata_option_frame <- gframe(text = "Import Columns",
                           horizontal = FALSE,
                           container = rdata_file_frame,
                           expand = TRUE)
rdata_option_group <- ggroup(use.scrollwindow = TRUE,
                           horizontal = FALSE,
                           expand = TRUE, 
                           container=rdata_option_frame)

rdata_export_frame <- gframe(text = "Export/Load",
                           horizontal = TRUE,
                           expand = FALSE,
                           container = rdata_file_frame)

rdata_export_button <- gbutton(text = "Export to R Data (RData)",
                             type = "save",
                             container = rdata_export_frame,
                             handler = function(h,...) {
                               # save file
                               # get enabled columns
                               colsel <- sapply(rbci.env$columnboxes,svalue)
                               
                               # read full-length file
                               rbci.env$importfile <- 
                                   load_obj(rbci.env$previewfile)
                               
                               eegdata <- 
                                   rbci.env$importfile
                               
                               save(eegdata,
                                    file = gfile(
                                      filter = list("RData"= 
                                                      list(patterns = 
                                                             c("*.RData"))),
                                      type = "save"))
                             })

rdata_load_button <- 
  gbutton(text = "Import into interface",
          container = rdata_export_frame,
          handler = function(h,...) {
            
            # get enabled columns
            colsel <- sapply(rbci.env$columnboxes,svalue)
            
            # read full-length file
            rbci.env$importfile <- 
              load_obj(rbci.env$previewfile)

            ## add imported data to list
            rbci.env$importlist[[
              basename(file_path_sans_ext(svalue(rdata_file_button)))]] <-
                rbci.env$importfile[,which(colsel==TRUE), with = FALSE]
            # in case of duplicates, mark explicitly
            names(rbci.env$importlist) <- 
              make.unique(names(rbci.env$importlist))
            
            # TODO cleanup importfile
            
            galert("Import succeeded.",
                   title = "Status",
                   delay = 2)
          })

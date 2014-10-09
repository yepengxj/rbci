bci_tab <- ggroup(container = import_tabs,
                      horizontal = FALSE,
                      label = "BCI2000")

bci_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = bci_tab)

bci_file_frame <- gframe(text = "File path",
                         horizontal = FALSE,
                         container = bci_pane)
#width = window.width/2)

bci_file_button <- gfilebrowse(text = "",
                               container = bci_file_frame,
                               quote = FALSE)
addHandlerChanged(bci_file_button,
                  handler=function(h,...) {
                    rbci.env$previewfile <- svalue(bci_file_button)
                  })

bci_preview_button <- 
  gbutton(text = "Preview",
          container = bci_file_frame,
          handler   = function(h, ...) {
            rbci.env$importfile <- read.table(rbci.env$previewfile,
                                              maxLength = 100000)
            # TODO add bci formatting options to GUI
            # delete previous preview frame if present
            if ("bci_preview_frame" %in% ls()) {
              delete(bci_pane, bci_preview_frame)
            }
            # react to preview type setting
            switch(svalue(bci_preview_type),
                   Columnar = {
                     # init tabular preview frame
                     bci_preview_frame <<- 
                       gtable(items = 
                                as.data.frame(
                                  rbci.env$importfile)[seq_len(preview.rowlen),],
                              container = bci_pane)
                     
                     # column selectors
                     # TODO clear previous columns
                     rbci.env$columnboxes <- c()
                     for (this.col in 
                          colnames(as.data.frame(rbci.env$importfile))) {
                       rbci.env$columnboxes <<- 
                         c(rbci.env$columnboxes,
                           gcheckbox(this.col,
                                     checked = FALSE,
                                     expand = FALSE,
                                     container = bci_option_group))
                     }
                   },
                   Structural = {
                     bci_preview_frame <<- 
                       gtext(text = paste(capture.output(str(
                         rbci.env$importfile)),"\n"),
                         container = bci_pane)
                   },
                   Raw = {
                     bci_preview_frame <<-
                       gtext(text = paste(capture.output(
                         print(sapply(rbci.env$importfile,head,n=2))),"\n"),
                         container = bci_pane)
                   })
          })

bci_preview_optframe <- gframe(text = "Preview Type",
                               container = bci_file_frame,
                               horizontal = TRUE,
                               expand = FALSE)
bci_preview_type <- gdroplist(items = c("Columnar","Structural","Raw"),
                              container = bci_preview_optframe,
                              fill = "x",
                              expand = TRUE)
bci_preview_rownum <- gspinbutton(from = 0, to = 20, by = 1,
                                  container = bci_preview_optframe)

bci_option_frame <- gframe(text = "Import Columns",
                           horizontal = FALSE,
                           container = bci_file_frame,
                           expand = TRUE)
bci_option_group <- ggroup(use.scrollwindow = TRUE,
                           horizontal = FALSE,
                           expand = TRUE, 
                           container=bci_option_frame)

bci_export_frame <- gframe(text = "Export/Load",
                           horizontal = TRUE,
                           expand = FALSE,
                           container = bci_file_frame)

bci_export_button <- gbutton(text = "Export to .RData",
                             type = "save",
                             container = bci_export_frame,
                             handler = function(h,...) {
                               # save file
                               # get enabled columns
                               colsel <- sapply(rbci.env$columnboxes,svalue)
                               
                               # read full-length file
                               rbci.env$importfile <- 
                                 readMat(rbci.env$previewfile)
                               
                               eegdata <- as.data.table(as.data.frame(
                                 rbci.env$importfile)[,which(colsel==TRUE)])
                               
                               save(eegdata,
                                    file = gfile(
                                      filter = list("RData"= list(patterns = c("*.RData"))),
                                      type = "save"))
                             })

bci_load_button <- 
  gbutton(text = "Import into interface",
          container = bci_export_frame,
          handler = function(h,...) {
            # rename, insert into interface
            
            # get enabled columns
            colsel <- sapply(rbci.env$columnboxes,svalue)
            
            # read full-length file
            rbci.env$importfile <- 
              readMat(rbci.env$previewfile)
            
            # add imported data to list
            rbci.env$importlist[[
              basename(file_path_sans_ext(svalue(bci_file_button)))]] <-
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
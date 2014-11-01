matlab_type2_tab <- ggroup(container = import_tabs,
                     horizontal = FALSE,
                     label = "MATLAB (Type 2)")

matlab_type2_pane <- gpanedgroup(horizontal = TRUE,
                           expand = TRUE,
                           fill = TRUE,
                           container = matlab_type2_tab)

matlab_type2_file_frame <- gframe(text = "File path",
                            horizontal = FALSE,
                            container = matlab_type2_pane)


matlab_type2_file_button <- gfilebrowse(text = "",
                                  container = matlab_type2_file_frame,
                                  quote = FALSE)
addHandlerChanged(matlab_type2_file_button,
                  handler=function(h,...) {
                    rbci.env$previewfile <- svalue(matlab_type2_file_button)
                  })

matlab_type2_preview_button <- 
  gbutton(text = "Preview",
          container = matlab_type2_file_frame,
          handler   = function(h, ...) {
            rbci.env$importfile <- readMat(rbci.env$previewfile,
                                           maxLength = 100000)
            
            eegdata <- 
              matlab_type2_import(rbci.env$importfile,
                                  eeg.ind = svalue(matlab_type2_eegindex),
                                  tgt.ind = svalue(matlab_type2_tgtindex),
                                  preview = TRUE)
            
            # delete previous preview frame if present
            if ("matlab_type2_preview_frame" %in% ls()) {
              delete(matlab_type2_pane, matlab_type2_preview_frame)
            }
            # react to preview type setting
            switch(svalue(matlab_type2_preview_type),
#                    Columnar = {
#                      # init tabular preview frame
#                      matlab_type2_preview_frame <<- 
#                        gtable(items = 
#                                 as.data.frame(
#                                   rbci.env$importfile)[seq_len(preview.rowlen),],
#                               container = matlab_type2_pane)
#                      
#                      # column selectors
#                      rbci.env$columnboxes <- c()
#                      for (this.col in 
#                           colnames(as.data.frame(rbci.env$importfile))) {
#                        rbci.env$columnboxes <<- 
#                          c(rbci.env$columnboxes,
#                            gcheckbox(this.col,
#                                      checked = FALSE,
#                                      expand = FALSE,
#                                      container = matlab_type2_option_group))
#                      }
#                    },
                   Structural = {
                     matlab_type2_preview_frame <<- 
                       gtext(text = paste(capture.output(str(
                         rbci.env$importfile)),"\n"),
                         container = matlab_type2_pane,
                         font.attr=c(family="monospace"))
                   },
                   Graphical = {
                     matlab_type2_preview_frame <<- 
                       ggraphics(container = matlab_type2_pane)
                     eegdata$preview.plot # should actually plot here
                   }
#                    Raw = {
#                      matlab_type2_preview_frame <<-
#                        gtext(text = paste(capture.output(
#                          print(sapply(rbci.env$importfile,head,n=2))),"\n"),
#                          container = matlab_type2_pane,
#                          font.attr=c(family="monospace"))
#                    })
            )
          })

matlab_type2_preview_optframe <- gframe(text = "",
                                  container = matlab_type2_file_frame,
                                  horizontal = FALSE,
                                  expand = FALSE)
glabel("Preview Type", container = matlab_type2_preview_optframe)
matlab_type2_preview_type <- gdroplist(items = c("Structural",
                                                 "Graphical"),
                                 container = matlab_type2_preview_optframe,
                                 fill = "x",
                                 expand = TRUE)
glabel("EEG index", container = matlab_type2_preview_optframe)
matlab_type2_eegindex <- gspinbutton(from = 1, 
                                     container = matlab_type2_preview_optframe)
glabel("Class label index", container = matlab_type2_preview_optframe)
matlab_type2_tgtindex <- gspinbutton(from = 1, 
                                     container = matlab_type2_preview_optframe)
# matlab_type2_preview_rownum <- gspinbutton(from = 0, to = 20, by = 1,
#                                      container = matlab_type2_preview_optframe)

# matlab_type2_option_frame <- gframe(text = "Import Columns",
#                               horizontal = FALSE,
#                               container = matlab_type2_file_frame,
#                               expand = TRUE)
# matlab_type2_option_group <- ggroup(use.scrollwindow = TRUE,
#                               horizontal = FALSE,
#                               expand = TRUE, 
#                               container=matlab_type2_option_frame)'

addSpring(matlab_type2_file_frame)

matlab_type2_export_frame <- gframe(text = "Export/Load",
                              horizontal = TRUE,
                              expand = FALSE,
                              container = matlab_type2_file_frame)

matlab_type2_export_button <- 
  gbutton(text = "Export to .RData",
          type = "save",
          container = matlab_type2_export_frame,
          handler = function(h,...) {
            # save file
            # get enabled columns
            colsel <- sapply(rbci.env$columnboxes,svalue)
            
            # read full-length file
            rbci.env$importfile <- 
              readMat(rbci.env$previewfile)
            
            eegdata <- 
              matlab_type2_import(rbci.env$importfile,
                                  eeg.ind = svalue(matlab_type2_eegindex),
                                  tgt.ind = svalue(matlab_type2_tgtindex),
                                  preview = FALSE)
            
            save(eegdata$eeg.table,
                 file = gfile(
                   filter = list("RData"= list(patterns = c("*.RData"))),
                   type = "save"))
          })

matlab_type2_load_button <- 
  gbutton(text = "Import into interface",
          container = matlab_type2_export_frame,
          handler = function(h,...) {
            # rename, insert into interface
            
            # get enabled columns
            # colsel <- sapply(rbci.env$columnboxes,svalue)
            
            # read full-length file
            rbci.env$importfile <- 
              readMat(rbci.env$previewfile)
            
            
            
            # add imported data to list
            rbci.env$importlist[[
              basename(file_path_sans_ext(svalue(matlab_type2_file_button)))]] <-
              matlab_type2_import(rbci.env$importfile,
                                  eeg.ind = svalue(matlab_type2_eegindex),
                                  tgt.ind = svalue(matlab_type2_tgtindex),
                                  preview = FALSE)$eeg.table
            # in case of duplicates, mark explicitly
            names(rbci.env$importlist) <- 
              make.unique(names(rbci.env$importlist))
            
            galert("Import succeeded.",
                   title = "Status",
                   delay = 2)
          })
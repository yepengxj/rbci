source("./backend/previewers.R")
source("./backend/importers.R")
library(R.matlab)

window.width <- 800
window.height <- 400

import_win <- gwindow("Data Import",
                      width = window.width,
                      height = window.height)

import_tabs <- gnotebook(tab.pos = 2,
                container = import_win)

csv_tab <- ggroup(container = import_tabs,
                  horizontal = FALSE,
                  label = "CSV/Text")

matlab_tab <- ggroup(container = import_tabs,
                  horizontal = FALSE,
                  label = "MATLAB")

bci2000_tab <- ggroup(container = import_tabs,
                     horizontal = FALSE,
                     label = "BCI2000")

matlab_pane <- gpanedgroup(horizontal = TRUE,
                           expand = FALSE,
                           fill = TRUE,
                           container = matlab_tab)

matlab_file_frame <- gframe(text = "File path",
                            horizontal = FALSE,
                            container = matlab_pane)
                            #width = window.width/2)

matlab_file_button <- gfilebrowse(text = "",
                                  container = matlab_file_frame,
                                  quote = FALSE)
addHandlerChanged(matlab_file_button,
                  handler=function(h,...) {
                    rbci.env$previewfile <- svalue(matlab_file_button)
                 })

matlab_preview_button <- gbutton(text = "Preview",
                                 container = matlab_file_frame,
                                 handler   = function(h, ...) {
                                   rbci.env$importfile <- 
                                     readMat(rbci.env$previewfile)
                                   
                                   # init preview frame
                                   matlab_preview_frame <- 
                                     gtable(items = as.data.frame(rbci.env$importfile)[1:10,],
                                                                  container = matlab_pane)
                                   
                                   # column selectors
                                   columnboxes <- c()
                                   for (this.col in colnames(as.data.frame(rbci.env$importfile))) {
                                     columnboxes <- c(columnboxes,
                                                      gcheckbox(this.col,
                                                                checked = TRUE,
                                                                expand = FALSE,
                                                                container = matlab_option_frame))
                                   }
                                 })

matlab_option_frame <- gframe(text = "Import options",
                              horizontal = FALSE,
                              container = matlab_file_frame,
                              expand = FALSE,
                              use.scrollwindow = TRUE)

matlab_export_frame <- gframe(text = "Export/Load",
                              horizontal = FALSE,
                              container = matlab_file_frame)
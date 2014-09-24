source("./backend/previewers.R")
source("./backend/importers.R")
library(R.matlab)

window.width <- 600

import_win <- gwindow("Data Import",
                      width = window.width)

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

matlab_pane <- gpanedgroup(horizontal = FALSE,
                           container = matlab_tab)

matlab_file_frame <- gframe(text = "File path",
                            horizontal = FALSE,
                            container = matlab_pane,
                            width = window.width/2)

matlab_file_button <- gfilebrowse(text = "",
                                  container = matlab_file_frame,
                                  handler = function(h,...) {
                                    rbci.env$previewfile <- h$file
                                  })
matlab_preview_button <- gbutton(text = "Preview",
                                 container = matlab_file_frame,
                                 handler   = function(h, ...) {
                                   rbci.env$importfile <- 
                                     read.mat(rbci.env$previewfile)
                                   
                                 })

matlab_option_frame <- gframe(text = "Import options",
                              horizontal = FALSE,
                              container = matlab_file_frame)

matlab_export_frame <- gframe(text = "Export/Load",
                              horizontal = FALSE,
                              container = matlab_file_frame)

matlab_preview_frame <- gtable(items = NULL, 
                               container = matlab_tab,
                               width = window.width/2)
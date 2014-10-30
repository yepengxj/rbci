source("./backend/previewers.R")
source("./backend/importers.R")

window.width <- 1000
window.height <- 600

preview.rowlen <- 20

import_win <- gwindow("Data Import",
                      width = window.width,
                      height = window.height)

import_tabs <- gnotebook(tab.pos = 2,
                container = import_win)

source("./gwidgets/import_interface_matlab.R")
source("./gwidgets/import_interface_matlab_type2.R")
source("./gwidgets/import_interface_csv.R")
source("./gwidgets/import_interface_rdata.R")
source("./gwidgets/import_interface_bci2000.R")
window.width <- 1000
window.height <- 600

preview.rowlen <- 20

import_win <- gwindow("Data Explorer",
                      width = window.width,
                      height = window.height)

import_tabs <- gnotebook(tab.pos = 2,
                         container = import_win)
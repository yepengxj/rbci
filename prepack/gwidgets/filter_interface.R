window.width <- 1000
window.height <- 600

preview.rowlen <- 20

filter_win <- gwindow("Filter Data",
                       width = window.width,
                       height = window.height)

filter_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = filter_win)


filter_var_group <- ggroup(use.scrollwindow = TRUE,
                            horizontal = FALSE,
                            expand = TRUE, 
                            container=filter_pane,
                            width = 200)
filter_var_frame <- gframe(text = "Data Sets",
                            horizontal = FALSE,
                            container = filter_var_group,
                            expand = TRUE)
# populate data set selector
# TODO add some kind of handler to refresh subitems in tables
filter_var_filesel <- gradio(names(rbci.env$importlist),
                              container = filter_var_frame)


filter_task_book <- gnotebook(tab.pos = 3,
                               container = filter_pane)

filter_simple_tab <- gframe(label = "Simple Filtering",
                            container = filter_task_book)

source("./gwidgets/filter_interface_simple.R")

# set some widths (doesn't work if earlier)
svalue(filter_pane) <- 0.2
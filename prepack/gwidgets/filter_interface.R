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

filter_task_book <- gnotebook(tab.pos = 3,
                               container = filter_pane)

filter_tab <- gframe(label = "Apply Filter",
                     container = filter_task_book)

summary_tab <- gframe(label = "Mean Spectra",
                      container = filter_task_book)
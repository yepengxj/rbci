window.width <- 1000
window.height <- 600

preview.rowlen <- 20

explore_win <- gwindow("Data Explorer",
                      width = window.width,
                      height = window.height)

explore_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = explore_win)


explore_var_group <- ggroup(use.scrollwindow = TRUE,
                           horizontal = FALSE,
                           expand = TRUE, 
                           container=explore_pane,
                           width = 200)
explore_var_frame <- gframe(text = "Data Sets",
                            horizontal = FALSE,
                            container = explore_var_group,
                            expand = TRUE)

explore_task_book <- gnotebook(tab.pos = 3,
                               container = explore_pane)

summary_tab <- gframe(label = "Summary",
                      container = explore_task_book)

means_tab <- gframe(label = "Grand Means",
                         container = explore_task_book)

histogram_tab <- gframe(label = "Histogram",
                         container = explore_task_book)

source("./gwidgets/explore_interface_summary.R")
source("./gwidgets/explore_interface_means.R")
# source("./gwidgets/explore_interface_histogram.R")
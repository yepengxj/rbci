window.width <- 1000
window.height <- 600


trans_win <- gwindow("Transform/Cluster Data",
                      width = window.width,
                      height = window.height)

trans_pane <- gpanedgroup(horizontal = TRUE,
                           expand = TRUE,
                           fill = TRUE,
                           container = trans_win)


trans_var_group <- ggroup(use.scrollwindow = TRUE,
                           horizontal = FALSE,
                           expand = TRUE, 
                           container=trans_pane,
                           width = 200)
trans_var_frame <- gframe(text = "Data Sets",
                           horizontal = FALSE,
                           container = trans_var_group,
                           expand = TRUE)
# populate data set selector
# TODO add some kind of handler to refresh subitems in tables
trans_var_filesel <- gradio(names(rbci.env$importlist),
                             container = trans_var_frame)


trans_task_book <- gnotebook(tab.pos = 3,
                              container = trans_pane)

trans_pca_tab <- gframe(label = "PCA",
                            container = trans_task_book)

trans_csp_tab <- gframe(label = "CSP",
                        container = trans_task_book)

trans_kmeans_tab <- gframe(label = "k-means",
                        container = trans_task_book)

source("./gwidgets/trans_interface_pca.R")
source("./gwidgets/trans_interface_csp.R")
source("./gwidgets/trans_interface_kmeans.R")

# set some widths (doesn't work if earlier)
svalue(trans_pane) <- 0.2

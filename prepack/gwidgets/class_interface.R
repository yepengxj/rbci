window.width <- 1000
window.height <- 600

preview.rowlen <- 20

class_win <- gwindow("Data Classifier",
                      width = window.width,
                      height = window.height)

class_pane <- gpanedgroup(horizontal = TRUE,
                          expand = TRUE,
                          fill = TRUE,
                          container = class_win)


class_var_group <- ggroup(use.scrollwindow = TRUE,
                          horizontal = FALSE,
                          expand = TRUE, 
                          container=class_pane,
                          width = 200)
class_var_frame <- gframe(text = "Data Sets",
                          horizontal = FALSE,
                          container = class_var_group,
                          expand = TRUE)
# populate data set selector
# TODO add some kind of handler to refresh subitems in tables
class_var_filesel <- gradio(names(rbci.env$importlist),
                            container = class_var_frame)


class_task_book <- gnotebook(tab.pos = 3,
                               container = class_pane)



text_tab <- gframe(label = "Text Info",
                      container = class_task_book)

plot_tab <- gframe(label = "Summary Plot",
                         container = class_task_book)

# hist_tab <- gframe(label = "Histogram",
#                          container = class_task_book)

# Load subitems (into tabs)
source("./gwidgets/class_interface_text.R")
# source("./gwidgets/class_interface_means.R")
# source("./gwidgets/class_interface_hist.R")

# set some widths (doesn't work if earlier)
svalue(class_pane) <- 0.2
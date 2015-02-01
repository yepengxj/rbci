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

## populate data set selector
if (!is.null(names(rbci.env$importlist))) {
    class_var_filesel <- gradio(names(rbci.env$importlist),
                                container = class_var_frame)
} else {
    class_var_filesel <- glabel("No data found.",
                                container = class_var_frame)
}

class_task_book <- gnotebook(tab.pos = 3,
                               container = class_pane)

sda_tab <- gframe(label = "SDA",
                   container = class_task_book)

svm_tab <- gframe(label = "SVM",
                   container = class_task_book)

bayes_tab <- gframe(label = "Naive Bayes",
                   container = class_task_book)

# Load subitems (into tabs)
source("./gwidgets/class_interface_sda.R")
source("./gwidgets/class_interface_svm.R")
source("./gwidgets/class_interface_bayes.R")

# set some widths (doesn't work if earlier)
svalue(class_pane) <- 0.3

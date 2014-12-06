library(gWidgets)
library(gWidgetsRGtk2)
options("guiToolkit"="RGtk2")

source("./backend/init_backend.R")

init_win <- gwindow("R BCI",
                    width = 200)

init_btn_group <- ggroup(container = init_win,
                         horizontal = FALSE)

import_btn <- gbutton(
  text      = "Import/Load Data",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/import_interface.R")
  })

explore_btn <- gbutton(
  text      = "Explore/Annotate Data",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/explore_interface.R")
  })

# stream_btn <- gbutton(
#   text      = "Create/Load Online Stream",
#   container = init_btn_group,
#   handler   = function(h, ...)
#   {
#     # TODO!
#   })

filter_btn <- gbutton(
  text      = "Filter Data",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/filter_interface.R")
  })

transform_btn <- gbutton(
  text      = "Transforms/Unsupervised Learning",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/trans_interface.R")
  })

classify_btn <- gbutton(
  text      = "Classification/Supervised Learning",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/class_interface.R")
  })

report_btn <- gbutton(
  text      = "Review/Generate Reports",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/report_interface.R")
  })

opts_btn <- gbutton(
  text      = "Parallelization Options",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/opts_interface.R")
  })

tool_btn <- gbutton(
  text      = "Custom Tool Designer",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    source("./gwidgets/tool_interface.R")
  })

quit_btn <- gbutton(
  text      = "Quit",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    dispose(init_win)
  })

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
    # TODO!
  })

stream_btn <- gbutton(
  text      = "Create/Load Online Stream",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    # TODO!
  })

tool_btn <- gbutton(
  text      = "Custom Tool Designer",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    # TODO!
  })

transform_btn <- gbutton(
  text      = "Transforms/Unsupervised Learning",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    # TODO!
  })

classify_btn <- gbutton(
  text      = "Classification/Supervised Learning",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    # TODO!
  })

report_btn <- gbutton(
  text      = "Review/Generate Reports",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    # TODO!
  })

quit_btn <- gbutton(
  text      = "Quit",
  container = init_btn_group,
  handler   = function(h, ...)
  {
    # TODO close all windows
  })
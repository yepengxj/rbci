window.width <- 1000
window.height <- 600

preview.rowlen <- 20

report_win <- gwindow("Report Generator",
                     width = window.width,
                     height = window.height)

report_pane <- gpanedgroup(horizontal = TRUE,
                          expand = TRUE,
                          fill = TRUE,
                          container = report_win)

process_group <- ggroup(use.scrollwindow = TRUE,
                          horizontal = FALSE,
                          expand = TRUE, 
                          container = report_pane,
                          width = 200)
process_frame <- gframe(text = "Processed Steps",
                          horizontal = FALSE,
                          container = process_group,
                          expand = TRUE)

### populate step selector
### TODO add some kind of handler to refresh subitems in tables
process_step_sel <- gtable(names(rbci.env$steplist),
                                   container = process_frame,
                                   use.table = TRUE,
                                   expand = TRUE)

### controls for changing step ordering 
process_step_up <- gbutton(
    text = "▲",
    container = process_frame,
    handler = function(h, ...) {
        scoot.gtable.row(process_step_sel,
                         svalue(process_step_sel, index = TRUE),
                         "up")
    })
process_step_down <-
    gbutton(text = "▼",
            container = process_frame,
            handler = function(h, ...) {
                scoot.gtable.row(process_step_sel,
                                 svalue(process_step_sel, index = TRUE),
                                 "down")
            })

# addSpring(process_frame)

## output options
# directory name
report_output_sel <- gfilebrowse(text = "Output directory name", 
                                 type = "selectdir",
                                 container = process_frame)

report_output_btn <- gbutton(text = "Generate Report",
                             container = process_frame)

report_task_book <- gnotebook(tab.pos = 3,
                             container = report_pane)

text_tab <- gframe(label = "Text",
                  container = report_task_book)

graphics_tab <- gframe(label = "Graphics",
                  container = report_task_book)

script_tab <- gframe(label = "Script",
                    container = report_task_book)


# Load subitems (into tabs)
source("./gwidgets/report_interface_text.R")
source("./gwidgets/report_interface_graphics.R")
source("./gwidgets/report_interface_script.R")

# set some widths (doesn't work if earlier)
svalue(report_pane) <- 0.2

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
process_step_sel <- gtable(tabulate.steplist(rbci.env$steplist),
                           container = process_frame,
                           use.table = TRUE,
                           expand = TRUE)

### update preview text, summary on selection change
addHandlerChanged(process_step_sel,
                  handler = function(h,...) {
                      code.text <-
                          process_step_sel[svalue(process_step_sel,index=TRUE),
                                           'code']
                      summary.text <-
                          process_step_sel[svalue(process_step_sel,index=TRUE),
                                           'summary']

                      svalue(step_code_text) <-
                          code.text
                      svalue(step_summary) <-
                          paste("Summary: ", summary.text)
                                
                  })
                      
### controls for changing step ordering/enabledness
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
process_step_toggle <-
    gbutton(text = "Enable/Disable",
            container = process_frame,
            handler = function(h, ...) {
                row.ind <- svalue(process_step_sel, index = TRUE)
                toggle.row(process_step_sel, # sets GUI part
                           row.ind)
                ## sets actual env list part
                rbci.env$steplist[[row.ind]]$enabled <- TRUE 
            })

# addSpring(process_frame)

## output options
# directory name
report_output_sel <- gfilebrowse(text = "Output directory name", 
                                 type = "selectdir",
                                 container = process_frame)

report_output_layout <- glayout(container = process_frame)

report_output_layout[1,1] <-
    gbutton(text = "Generate Report",
            handler = function(h,...) {

                report.steps <- process_step_sel
                report.title <- svalue(report_opts_title)
                report.auth <- svalue(report_opts_author)
                report.dir <- svalue(report_output_sel)
                report.knit <- svalue(report_output_layout[1,2])

                build.report(report.steps, report.title,
                             report.auth, report.dir, report.knit)
            })

report_output_layout[1,2] <-
    gcheckbox("Run exported report and remove disabled steps?")

# Load subitems (into tabs)
source("./gwidgets/report_interface_text.R")

# set some widths (doesn't work if earlier)
svalue(report_pane) <- 0.4

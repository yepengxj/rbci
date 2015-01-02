# text_pane <- gpanedgroup(horizontal = FALSE,
#                          expand = TRUE,
#                          fill = TRUE,
#                          container = report_pane)

text_pane_group <- ggroup(container = report_pane,
                          horizontal = FALSE)

step_summary <- glabel("Summary: ",
                       container = text_pane_group)

step_code_frame <- gframe("Section Code",
                          horizontal = FALSE,
                          container = text_pane_group,
                          expand = TRUE)

step_code_text <- gtext(container = step_code_frame, # step_code_frame,
                        font.attr = c(family="monospace"),
                        expand = TRUE)

step_run_export <-
    gbutton("Run This Step and Save",
            container = step_code_frame,
            handler = function(h,...){
                this.step.code <-
                    svalue(process_step_sel,"code")
                
                save(export.single.step(this.step.code),
                     file = gfile(
                         filter = list("RData" = list(patterns = c("*.RData"))),
                         type = "save"))
            })

report_opts_frame <- gframe("Report Options",
                            horizontal = TRUE,
                            container = text_pane_group)

report_opts_title <- glabel("Report Title",
                            editable = TRUE,
                            container = report_opts_frame,
                            expand = TRUE)

report_opts_author <- glabel("Report Author",
                             editable = TRUE,
                             container = report_opts_frame,
                             expand = TRUE)


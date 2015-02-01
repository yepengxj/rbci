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


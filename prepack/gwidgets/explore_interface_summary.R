summary_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = summary_tab)

summary_varlist_group <- ggroup(use.scrollwindow = TRUE,
                                horizontal = FALSE,
                                expand = TRUE,
                                container = summary_pane)
summary_varlist_frame <- gframe(text = "Data Columns",
                                horizontal = FALSE,
                                container = summary_varlist_group,
                                expand = TRUE)
summary_varlist_btn <- gbutton(text = "Summarize",
                               container = summary_varlist_group,
                               handler = function(h,...) {
                               })

summary_output_frame <- gtext(text = "Summary output",
                              container = summary_pane)


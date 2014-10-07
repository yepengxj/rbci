means_pane <- gpanedgroup(horizontal = TRUE,
                          expand = TRUE,
                          fill = TRUE,
                          container = means_tab)

means_varlist_group <- ggroup(use.scrollwindow = TRUE,
                              horizontal = FALSE,
                              expand = TRUE,
                              container = means_pane)
means_varlist_frame <- gframe(text = "Data Columns",
                              horizontal = FALSE,
                              container = means_varlist_group,
                              expand = TRUE)

means_varlist_btn <- gbutton(text = "Summarize",
                               container = means_varlist_group,
                               handler = function(h,...) {
                            })

means_output_frame <- ggraphics(container = means_pane)


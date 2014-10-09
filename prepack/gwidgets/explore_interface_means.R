means_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = means_tab)


means_varlist_frame <- gframe(text = "Data Columns",
                                horizontal = FALSE,
                                container = means_pane,
                                expand = TRUE,
                                width = 300)
# populate varlist
means_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]),
  container = means_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

means_plot_btn <- gbutton(text = "Plot",
                                 container = means_varlist_frame,
                                 handler = function(h,...) {
                                 })

means_output_frame <- ggraphics(container = means_pane)

svalue(means_pane) <- 0.2
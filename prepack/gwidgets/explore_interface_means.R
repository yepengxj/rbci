means_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = means_tab)


means_varlist_frame <- gframe(text = "Data Columns",
                                horizontal = FALSE,
                                container = means_pane,
                                expand = TRUE,
                                width = 300)

### TODO: is this needed after allowing annotations?
# populate varlist
means_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]),
  container = means_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

### if above checkboxgroup not used, check for annotations and send
### user alert if not present
means_plot_btn <-
    gbutton(text = "Plot",
            container = means_varlist_frame,
            handler = function(h,...) {
                
                print(
                    grand.means.plot(
                    rbci.env$importlist[[svalue(explore_var_filesel,
                                                index=TRUE)]],
                        val.name = rbci.env$tags[[svalue(explore_var_filesel,
                            index=TRUE)]]$valuecol,
                        col.groups =
                            setdiff(names(rbci.env$importlist[[svalue(explore_var_filesel,
                                                                      index=TRUE)]]),
                                    c(rbci.env$tags[[svalue(explore_var_filesel,
                                                            index=TRUE)]]$valuecol,
                                      rbci.env$tags[[svalue(explore_var_filesel,
                                                            index=TRUE)]]$targetcol,
                                  rbci.env$tags[[svalue(explore_var_filesel,
                                                        index=TRUE)]]$epochcol))
                    )
                )
            })

means_output_frame <- ggraphics(container = means_pane)

svalue(means_pane) <- 0.2

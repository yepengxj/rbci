means_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = means_tab)

### if above checkboxgroup not used, check for annotations and send
### user alert if not present
means_plot_btn <-
    gbutton(text = "Plot",
            container = means_varlist_frame,
            handler = function(h,...) {
                curfileind <- svalue(explore_var_filesel,index=TRUE)
                print(curfileind)
                print(
                    grand.means.plot(
                        rbci.env$importlist[[curfileind]],
                        val.name = rbci.env$tags[[curfileind]]$valuecol,
                        time.name = rbci.env$tags[[curfileind]]$timecol,
                        chan.name = rbci.env$tags[[curfileind]]$chancol,
                        targ.name = rbci.env$tags[[curfileind]]$targetcol
                    )
                )
            })

means_output_frame <- ggraphics(container = means_pane)

svalue(means_pane) <- 0.2

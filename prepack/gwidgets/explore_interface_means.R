means_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = means_tab)



means_param_frame <- gframe(text = "",
                                horizontal = FALSE,
                                container = means_pane,
                                expand = TRUE,
                                width = 300)
## application params
means_grouping_frame <- gframe(text = "",
                             horizontal = FALSE,
                             container = means_param_frame,
                             expand = TRUE,
                             width = 300)


# trial/group vars
means_grouping_label <- glabel(text = "Data Grouping",
                                container = means_grouping_frame)
means_grouping_layout <- glayout(container = means_grouping_frame)

means_grouping_layout[1,1] <- "Data Variable (Voltage)"
means_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]))

means_grouping_layout[3,1] <- "Time Variable (Sample)"
means_grouping_layout[4,1] <- 
  gcombobox(
      names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]))

means_grouping_layout[5,1] <- "Target Variable (Class)"
means_grouping_layout[6,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]))

means_grouping_layout[7,1] <- "Second Group (Channel)"
means_grouping_layout[8,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]))


### user alert if not present
means_plot_btn <-
    gbutton(text = "Plot",
            container = means_param_frame,
            handler = function(h,...) {
                this.args <-
                    list(
                        eeg.table =
                            bquote( # partially dereference call
                              rbci.env$importlist[[.(svalue(explore_var_filesel))]]),
                        val.name = svalue(means_grouping_layout[2,1]),
                        time.name = svalue(means_grouping_layout[4,1]),
                        chan.name = svalue(means_grouping_layout[8,1]),
                        targ.name = svalue(means_grouping_layout[6,1])
                        )
                
                print(do.call(
                    grand.means.plot,
                    this.args)
                    )

                add.step(func.name = "grand.means.plot",
                         step.args = this.args)
            })

means_output_frame <- ggraphics(container = means_pane)

svalue(means_pane) <- 0.2

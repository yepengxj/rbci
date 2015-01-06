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
                means.data <-
                    rbci.env$importlist[[svalue(explore_var_filesel,index=TRUE)]]
                means.val <- svalue(means_grouping_layout[2,1])
                means.time <- svalue(means_grouping_layout[4,1])
                means.chan <- svalue(means_grouping_layout[8,1])
                means.targ <- svalue(means_grouping_layout[6,1])
                
                print(
                    grand.means.plot(
                        means.data,
                        means.val,
                        means.time,
                        means.chan,
                        means.targ
                    )
                )
            })

means_output_frame <- ggraphics(container = means_pane)

svalue(means_pane) <- 0.2

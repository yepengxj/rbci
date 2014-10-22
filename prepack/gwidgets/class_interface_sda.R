# button pane
sda_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = sda_tab)


sda_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = sda_pane,
                            expand = TRUE,
                            width = 300)
# populate varlist
# TODO Update features spinbox on change
sda_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
  container = sda_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

sda_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = sda_pane)


## sda params
sda_param_frame <- gframe(text = "SDA Parameters",
                          horizontal = FALSE,
                          container = sda_action_pane,
                          expand = TRUE,
                          width = 300)

## opts

# numerical entries (spinboxes)
sda_band_label <- glabel(text = "Numerical Parameters",
                         container = sda_param_frame)
sda_band_layout <- glayout(container = sda_param_frame)


sda_band_layout[1,1] <- "Shrinkage (correlation matrix)"
sda_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
sda_band_layout[1,2] <- "Shrinkage (variances)"
sda_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
sda_band_layout[3,1] <- "Shrinkage (frequencies)"
sda_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)


## application params
sda_grouping_frame <- gframe(text = "Data Grouping",
                             horizontal = FALSE,
                             container = sda_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
sda_grouping_layout <- glayout(container = sda_grouping_frame)

sda_grouping_layout[1,1] <- "First Group (Trial)"
sda_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

sda_grouping_layout[3,1] <- "Second Group (Channel)"
sda_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

## output params
sda_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = sda_param_frame,
                           expand = TRUE,
                           width = 300)

# apply sda button
sda_apply_btn <- gbutton("Run",
                         container = sda_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)
tool_output_name <- gedit(text = "Output.Variable",
                          container = sda_output_frame,
                          width = 25)

# save sda
sda_save_btn <- gfilebrowse(text = "Save Model",
                            type = "save",
                            container = sda_output_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # save file
                              
                              # update list to include
                              
                            })


# plot variances
sda_variance_btn <- gbutton("Print Table",
                            container = sda_output_frame)
sda_subspace_btn <- gbutton("Print Model",
                            container = sda_output_frame)



sda_output_frame <- gtext(text = "sda output",
                           font.attr=c(family="monospace"),
                           width = window.width*0.4,
                           container = sda_pane)

# set some widths (doesn't work if earlier)
svalue(sda_pane) <- 0.2
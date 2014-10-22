# button pane
svm_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = svm_tab)


svm_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = svm_pane,
                            expand = TRUE,
                            width = 300)
# populate varlist
# TODO Update features spinbox on change
svm_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
  container = svm_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

svm_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = svm_pane)


## svm params
svm_param_frame <- gframe(text = "svm Parameters",
                          horizontal = FALSE,
                          container = svm_action_pane,
                          expand = TRUE,
                          width = 300)

## opts

# numerical entries (spinboxes)
svm_band_label <- glabel(text = "Numerical Parameters",
                         container = svm_param_frame)
svm_band_layout <- glayout(container = svm_param_frame)


svm_band_layout[1,1] <- "Shrinkage (correlation matrix)"
svm_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
svm_band_layout[1,2] <- "Shrinkage (variances)"
svm_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
svm_band_layout[3,1] <- "Shrinkage (frequencies)"
svm_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)


## application params
svm_grouping_frame <- gframe(text = "Data Grouping",
                             horizontal = FALSE,
                             container = svm_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
svm_grouping_layout <- glayout(container = svm_grouping_frame)

svm_grouping_layout[1,1] <- "First Group (Trial)"
svm_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

svm_grouping_layout[3,1] <- "Second Group (Channel)"
svm_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

## output params
svm_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = svm_param_frame,
                           expand = TRUE,
                           width = 300)

# apply svm button
svm_apply_btn <- gbutton("Run",
                         container = svm_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)
tool_output_name <- gedit(text = "Output.Variable",
                          container = svm_output_frame,
                          width = 25)

# save svm
svm_save_btn <- gfilebrowse(text = "Save Model",
                            type = "save",
                            container = svm_output_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # save file
                              
                              # update list to include
                              
                            })


# plot variances
svm_variance_btn <- gbutton("Print Table",
                            container = svm_output_frame)
svm_subspace_btn <- gbutton("Print Model",
                            container = svm_output_frame)



svm_output_frame <- gtext(text = "svm output",
                          font.attr=c(family="monospace"),
                          width = window.width*0.4,
                          container = svm_pane)

# set some widths (doesn't work if earlier)
svalue(svm_pane) <- 0.2
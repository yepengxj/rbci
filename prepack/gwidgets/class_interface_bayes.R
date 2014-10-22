# button pane
bayes_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = bayes_tab)


bayes_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = bayes_pane,
                            expand = TRUE,
                            width = 300)
# populate varlist
# TODO Update features spinbox on change
bayes_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
  container = bayes_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

bayes_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = bayes_pane)


## bayes params
bayes_param_frame <- gframe(text = "Naive Bayes Parameters",
                          horizontal = FALSE,
                          container = bayes_action_pane,
                          expand = TRUE,
                          width = 300)

## opts

# numerical entries (spinboxes)
bayes_band_label <- glabel(text = "Numerical Parameters",
                         container = bayes_param_frame)
bayes_band_layout <- glayout(container = bayes_param_frame)


bayes_band_layout[1,1] <- "Laplace smoothing"
bayes_band_layout[2,1] <- gspinbutton(from = 0, by = 0.01)

# # stop band end
# bayes_band_layout[1,2] <- "Shrinkage (variances)"
# bayes_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)
# 
# # pass band start
# bayes_band_layout[3,1] <- "Shrinkage (frequencies)"
# bayes_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)


## application params
bayes_grouping_frame <- gframe(text = "Data Grouping",
                             horizontal = FALSE,
                             container = bayes_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
bayes_grouping_layout <- glayout(container = bayes_grouping_frame)

bayes_grouping_layout[1,1] <- "First Group (Trial)"
bayes_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

bayes_grouping_layout[3,1] <- "Second Group (Channel)"
bayes_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

## output params
bayes_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = bayes_param_frame,
                           expand = TRUE,
                           width = 300)

# apply bayes button
bayes_apply_btn <- gbutton("Run",
                         container = bayes_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)
model_output_name <- gedit(text = "Model.Output.Var",
                           container = bayes_output_frame,
                           width = 25)
result_output_name <- gedit(text = "Result.Output.Var",
                            container = bayes_output_frame,
                            width = 25)


# save bayes
bayes_save_btn <- gfilebrowse(text = "Save Model",
                            type = "save",
                            container = bayes_output_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # save file
                              
                              # update list to include
                              
                            })


# plot variances
bayes_table_btn <- gbutton("Print Table",
                         container = bayes_output_frame)
bayes_model_btn <- gbutton("Print Model",
                         container = bayes_output_frame)
bayes_plot_btn <- gbutton("Plot Model (Overview)",
                        container = bayes_output_frame)


bayes_output_frame <- gtext(text = "bayes output",
                          font.attr=c(family="monospace"),
                          width = window.width*0.4,
                          container = bayes_pane)

# set some widths (doesn't work if earlier)
svalue(bayes_pane) <- 0.2
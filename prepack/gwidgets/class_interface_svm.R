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
svm_kernel_type_list <- c("Linear (LiblineaR)","Gaussian (kernlab)",
                          "Laplace (kernlab)","Polynomial (kernlab)",
                          "Hyperbolic (kernlab)","Bessel (kernlab)",
                          "ANOVA RBF (kernlab)", "Spline (kernlab)")
svm_kernel_type_label <- glabel(text = "Kernel Type (library)",
                                container = svm_param_frame)
svm_kernel_type_menu <- 
  gdroplist(svm_kernel_type_list,
            text = "Kernel Type",
            container = svm_param_frame,
            handler = function (h,...) {
              # enable or disable param GUI opts on type change
              
              ## param names by type
              # sigma for rbf/Laplace
              # degree, scale, offset for Polynomial
              # scale, offset for tanhdot
              # sigma, order, degree, for Bessel
              # sigma, degree for ANOVA
              switch (svalue(h$obj),
                      "Linear (LiblineaR)" = {
                        enabled(svm_band_layout[1,1]) <- FALSE
                        enabled(svm_band_layout[2,1]) <- FALSE
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Laplace (kernlab)" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Sigma"
                        
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Gaussian (kernlab)" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Sigma"
                        
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Polynomial (kernlab)" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Degree"
                        
                        enabled(svm_band_layout[1,2]) <- TRUE
                        enabled(svm_band_layout[2,2]) <- TRUE
                        svalue(svm_band_layout[1,2]) <- "Scale"
                        
                        enabled(svm_band_layout[3,1]) <- TRUE
                        enabled(svm_band_layout[4,1]) <- TRUE
                        svalue(svm_band_layout[3,1]) <- "Offset"
                      },
                      "Hyperbolic (kernlab)" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Scale"
                        
                        enabled(svm_band_layout[1,2]) <- TRUE
                        enabled(svm_band_layout[2,2]) <- TRUE
                        svalue(svm_band_layout[1,2]) <- "Offset"
                        
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Bessel (kernlab)" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Sigma"
                        
                        enabled(svm_band_layout[1,2]) <- TRUE
                        enabled(svm_band_layout[2,2]) <- TRUE
                        svalue(svm_band_layout[1,2]) <- "Order"
                        
                        enabled(svm_band_layout[3,1]) <- TRUE
                        enabled(svm_band_layout[4,1]) <- TRUE
                        svalue(svm_band_layout[3,1]) <- "Degree"
                      },
                      "ANOVA RBF (kernlab)" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Sigma"
                        
                        enabled(svm_band_layout[1,2]) <- TRUE
                        enabled(svm_band_layout[2,2]) <- TRUE
                        svalue(svm_band_layout[1,2]) <- "Degree"
                        
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Spline (kernlab)" = {
                        enabled(svm_band_layout[1,1]) <- FALSE
                        enabled(svm_band_layout[2,1]) <- FALSE
                        
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      })
            })


# numerical entries (spinboxes)
svm_band_label <- glabel(text = "Numerical Parameters",
                         container = svm_param_frame)
svm_band_layout <- glayout(container = svm_param_frame)


svm_band_layout[1,1] <- ""
svm_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
svm_band_layout[1,2] <- ""
svm_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
svm_band_layout[3,1] <- ""
svm_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band end
svm_band_layout[3,2] <- "# of Features (0 = all)"
svm_band_layout[4,2] <- gspinbutton(from = 0, to = length(svm_varlist), by = 1)
enabled(svm_band_layout[1,1]) <- FALSE
enabled(svm_band_layout[2,1]) <- FALSE
enabled(svm_band_layout[1,2]) <- FALSE
enabled(svm_band_layout[2,2]) <- FALSE
enabled(svm_band_layout[3,1]) <- FALSE
enabled(svm_band_layout[4,1]) <- FALSE


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

# training/test fractions

## output params
svm_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = svm_param_frame,
                           expand = TRUE,
                           width = 300)

# apply svm button
svm_apply_btn <- gbutton("Train",
                         container = svm_output_frame)
svm_apply_btn <- gbutton("Test",
                         container = svm_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)
tool_output_name <- gedit(text = "Model.Output.Var",
                          container = svm_output_frame,
                          width = 25)
result_output_name <- gedit(text = "Result.Output.Var",
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

# plot pane

# svm plot on right side
svm_plot_frame <- ggraphics(container = svm_action_pane)

# set some widths (doesn't work if earlier)
svalue(svm_pane) <- 0.2
svalue(svm_action_pane) <- 0.2
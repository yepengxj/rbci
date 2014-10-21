# button pane
sda_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = sda_tab)


sda_varlist_frame <- gframe(sda = "Apply Columns",
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
sda_param_frame <- gframe(sda = "sda Parameters",
                          horizontal = FALSE,
                          container = sda_action_pane,
                          expand = TRUE,
                          width = 300)

## opts
sda_kernel_type_list <- c("Linear","Gaussian","Laplace","Polynomial","Hyperbolic",
                          "Bessel","ANOVA")
sda_kernel_type_label <- glabel(sda = "Kernel Type",
                                container = sda_param_frame)
sda_kernel_type_menu <- 
  gdroplist(sda_kernel_type_list,
            sda = "Kernel Type",
            container = sda_param_frame,
            handler = function (h,...) {
              # enable or disable param GUI opts on type change
              
              ## param names by type
              # sigma for rbf/Laplace
              # degree, scale, offset for Polynomial
              # scale, offset for tanhdot
              # sigma, order, degree, for Bessel
              # sigma, degree for ANOVA
              switch (svalue(h$obj),
                      "Linear" = {
                        enabled(sda_band_layout[1,1]) <- FALSE
                        enabled(sda_band_layout[2,1]) <- FALSE
                        enabled(sda_band_layout[1,2]) <- FALSE
                        enabled(sda_band_layout[2,2]) <- FALSE
                        enabled(sda_band_layout[3,1]) <- FALSE
                        enabled(sda_band_layout[4,1]) <- FALSE
                      },
                      "Laplace" = {
                        enabled(sda_band_layout[1,1]) <- TRUE
                        enabled(sda_band_layout[2,1]) <- TRUE
                        svalue(sda_band_layout[1,1]) <- "Sigma"
                        
                        enabled(sda_band_layout[1,2]) <- FALSE
                        enabled(sda_band_layout[2,2]) <- FALSE
                        enabled(sda_band_layout[3,1]) <- FALSE
                        enabled(sda_band_layout[4,1]) <- FALSE
                      },
                      "Gaussian" = {
                        enabled(sda_band_layout[1,1]) <- TRUE
                        enabled(sda_band_layout[2,1]) <- TRUE
                        svalue(sda_band_layout[1,1]) <- "Sigma"
                        
                        enabled(sda_band_layout[1,2]) <- FALSE
                        enabled(sda_band_layout[2,2]) <- FALSE
                        enabled(sda_band_layout[3,1]) <- FALSE
                        enabled(sda_band_layout[4,1]) <- FALSE
                      },
                      "Polynomial" = {
                        enabled(sda_band_layout[1,1]) <- TRUE
                        enabled(sda_band_layout[2,1]) <- TRUE
                        svalue(sda_band_layout[1,1]) <- "Degree"
                        
                        enabled(sda_band_layout[1,2]) <- TRUE
                        enabled(sda_band_layout[2,2]) <- TRUE
                        svalue(sda_band_layout[1,2]) <- "Scale"
                        
                        enabled(sda_band_layout[3,1]) <- TRUE
                        enabled(sda_band_layout[4,1]) <- TRUE
                        svalue(sda_band_layout[3,1]) <- "Offset"
                      },
                      "Hyperbolic" = {
                        enabled(sda_band_layout[1,1]) <- TRUE
                        enabled(sda_band_layout[2,1]) <- TRUE
                        svalue(sda_band_layout[1,1]) <- "Scale"
                        
                        enabled(sda_band_layout[1,2]) <- TRUE
                        enabled(sda_band_layout[2,2]) <- TRUE
                        svalue(sda_band_layout[1,2]) <- "Offset"
                        
                        enabled(sda_band_layout[3,1]) <- FALSE
                        enabled(sda_band_layout[4,1]) <- FALSE
                      },
                      "Bessel" = {
                        enabled(sda_band_layout[1,1]) <- TRUE
                        enabled(sda_band_layout[2,1]) <- TRUE
                        svalue(sda_band_layout[1,1]) <- "Sigma"
                        
                        enabled(sda_band_layout[1,2]) <- TRUE
                        enabled(sda_band_layout[2,2]) <- TRUE
                        svalue(sda_band_layout[1,2]) <- "Order"
                        
                        enabled(sda_band_layout[3,1]) <- TRUE
                        enabled(sda_band_layout[4,1]) <- TRUE
                        svalue(sda_band_layout[3,1]) <- "Degree"
                      },
                      "ANOVA" = {
                        enabled(sda_band_layout[1,1]) <- TRUE
                        enabled(sda_band_layout[2,1]) <- TRUE
                        svalue(sda_band_layout[1,1]) <- "Sigma"
                        
                        enabled(sda_band_layout[1,2]) <- TRUE
                        enabled(sda_band_layout[2,2]) <- TRUE
                        svalue(sda_band_layout[1,2]) <- "Degree"
                        
                        enabled(sda_band_layout[3,1]) <- FALSE
                        enabled(sda_band_layout[4,1]) <- FALSE
                      })
            })


# numerical entries (spinboxes)
sda_band_label <- glabel(sda = "Numerical Parameters",
                         container = sda_param_frame)
sda_band_layout <- glayout(container = sda_param_frame)


sda_band_layout[1,1] <- ""
sda_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
sda_band_layout[1,2] <- ""
sda_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
sda_band_layout[3,1] <- ""
sda_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band end
sda_band_layout[3,2] <- "# of Features (0 = all)"
sda_band_layout[4,2] <- gspinbutton(from = 0, to = length(sda_varlist), by = 1)
enabled(sda_band_layout[1,1]) <- FALSE
enabled(sda_band_layout[2,1]) <- FALSE
enabled(sda_band_layout[1,2]) <- FALSE
enabled(sda_band_layout[2,2]) <- FALSE
enabled(sda_band_layout[3,1]) <- FALSE
enabled(sda_band_layout[4,1]) <- FALSE


## application params
sda_grouping_frame <- gframe(sda = "Data Grouping",
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
sda_output_frame <- gframe(sda = "KL Output Options",
                           horizontal = FALSE,
                           container = sda_param_frame,
                           expand = TRUE,
                           width = 300)

# apply sda button
sda_apply_btn <- gbutton("Apply KL to Data",
                         container = sda_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)
tool_output_name <- gedit(sda = "Output.Variable",
                          container = sda_output_frame,
                          width = 25)

# save sda
sda_save_btn <- gfilebrowse(sda = "Save Transformed Data",
                            type = "save",
                            container = sda_output_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # save file
                              
                              # update list to include
                              
                            })


# plot variances
sda_variance_btn <- gbutton("Plot Eigenvalues",
                            container = sda_output_frame)
sda_subspace_btn <- gbutton("Plot 2D Subspaces",
                            container = sda_output_frame)



sda_output_frame <- gsda(sda = "sda output",
                           font.attr=c(family="monospace"),
                           width = window.width*0.4,
                           container = sda_pane)

# set some widths (doesn't work if earlier)
svalue(sda_pane) <- 0.2
# button pane
kmeans_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = trans_kmeans_tab)


kmeans_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = kmeans_pane,
                            expand = TRUE,
                            width = 300)
# populate varlist
# TODO Update features spinbox on change
kmeans_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]),
  container = kmeans_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

kmeans_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = kmeans_pane)


## kmeans params
kmeans_param_frame <- gframe(text = "kmeans Parameters",
                          horizontal = FALSE,
                          container = kmeans_action_pane,
                          expand = TRUE,
                          width = 300)

## opts
kmeans_kernel_type_list <- c("Linear","Gaussian","Laplace","Polynomial","Hyperbolic",
                          "Bessel","ANOVA")
kmeans_kernel_type_label <- glabel(text = "Kernel Type",
                                container = kmeans_param_frame)
kmeans_kernel_type_menu <- 
  gdroplist(kmeans_kernel_type_list,
            text = "Kernel Type",
            container = kmeans_param_frame,
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
                        enabled(kmeans_band_layout[1,1]) <- FALSE
                        enabled(kmeans_band_layout[2,1]) <- FALSE
                        enabled(kmeans_band_layout[1,2]) <- FALSE
                        enabled(kmeans_band_layout[2,2]) <- FALSE
                        enabled(kmeans_band_layout[3,1]) <- FALSE
                        enabled(kmeans_band_layout[4,1]) <- FALSE
                      },
                      "Laplace" = {
                        enabled(kmeans_band_layout[1,1]) <- TRUE
                        enabled(kmeans_band_layout[2,1]) <- TRUE
                        svalue(kmeans_band_layout[1,1]) <- "Sigma"
                        
                        enabled(kmeans_band_layout[1,2]) <- FALSE
                        enabled(kmeans_band_layout[2,2]) <- FALSE
                        enabled(kmeans_band_layout[3,1]) <- FALSE
                        enabled(kmeans_band_layout[4,1]) <- FALSE
                      },
                      "Gaussian" = {
                        enabled(kmeans_band_layout[1,1]) <- TRUE
                        enabled(kmeans_band_layout[2,1]) <- TRUE
                        svalue(kmeans_band_layout[1,1]) <- "Sigma"
                        
                        enabled(kmeans_band_layout[1,2]) <- FALSE
                        enabled(kmeans_band_layout[2,2]) <- FALSE
                        enabled(kmeans_band_layout[3,1]) <- FALSE
                        enabled(kmeans_band_layout[4,1]) <- FALSE
                      },
                      "Polynomial" = {
                        enabled(kmeans_band_layout[1,1]) <- TRUE
                        enabled(kmeans_band_layout[2,1]) <- TRUE
                        svalue(kmeans_band_layout[1,1]) <- "Degree"
                        
                        enabled(kmeans_band_layout[1,2]) <- TRUE
                        enabled(kmeans_band_layout[2,2]) <- TRUE
                        svalue(kmeans_band_layout[1,2]) <- "Scale"
                        
                        enabled(kmeans_band_layout[3,1]) <- TRUE
                        enabled(kmeans_band_layout[4,1]) <- TRUE
                        svalue(kmeans_band_layout[3,1]) <- "Offset"
                      },
                      "Hyperbolic" = {
                        enabled(kmeans_band_layout[1,1]) <- TRUE
                        enabled(kmeans_band_layout[2,1]) <- TRUE
                        svalue(kmeans_band_layout[1,1]) <- "Scale"
                        
                        enabled(kmeans_band_layout[1,2]) <- TRUE
                        enabled(kmeans_band_layout[2,2]) <- TRUE
                        svalue(kmeans_band_layout[1,2]) <- "Offset"
                        
                        enabled(kmeans_band_layout[3,1]) <- FALSE
                        enabled(kmeans_band_layout[4,1]) <- FALSE
                      },
                      "Bessel" = {
                        enabled(kmeans_band_layout[1,1]) <- TRUE
                        enabled(kmeans_band_layout[2,1]) <- TRUE
                        svalue(kmeans_band_layout[1,1]) <- "Sigma"
                        
                        enabled(kmeans_band_layout[1,2]) <- TRUE
                        enabled(kmeans_band_layout[2,2]) <- TRUE
                        svalue(kmeans_band_layout[1,2]) <- "Order"
                        
                        enabled(kmeans_band_layout[3,1]) <- TRUE
                        enabled(kmeans_band_layout[4,1]) <- TRUE
                        svalue(kmeans_band_layout[3,1]) <- "Degree"
                      },
                      "ANOVA" = {
                        enabled(kmeans_band_layout[1,1]) <- TRUE
                        enabled(kmeans_band_layout[2,1]) <- TRUE
                        svalue(kmeans_band_layout[1,1]) <- "Sigma"
                        
                        enabled(kmeans_band_layout[1,2]) <- TRUE
                        enabled(kmeans_band_layout[2,2]) <- TRUE
                        svalue(kmeans_band_layout[1,2]) <- "Degree"
                        
                        enabled(kmeans_band_layout[3,1]) <- FALSE
                        enabled(kmeans_band_layout[4,1]) <- FALSE
                      })
            })


# numerical entries (spinboxes)
kmeans_band_label <- glabel(text = "Numerical Parameters",
                         container = kmeans_param_frame)
kmeans_band_layout <- glayout(container = kmeans_param_frame)


kmeans_band_layout[1,1] <- ""
kmeans_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
kmeans_band_layout[1,2] <- ""
kmeans_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
kmeans_band_layout[3,1] <- ""
kmeans_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band end
kmeans_band_layout[3,2] <- "# of Features (0 = all)"
kmeans_band_layout[4,2] <- gspinbutton(from = 0, to = length(kmeans_varlist), by = 1)
enabled(kmeans_band_layout[1,1]) <- FALSE
enabled(kmeans_band_layout[2,1]) <- FALSE
enabled(kmeans_band_layout[1,2]) <- FALSE
enabled(kmeans_band_layout[2,2]) <- FALSE
enabled(kmeans_band_layout[3,1]) <- FALSE
enabled(kmeans_band_layout[4,1]) <- FALSE


## application params
kmeans_grouping_frame <- gframe(text = "Data Grouping",
                             horizontal = FALSE,
                             container = kmeans_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
kmeans_grouping_layout <- glayout(container = kmeans_grouping_frame)

kmeans_grouping_layout[1,1] <- "First Group (Trial)"
kmeans_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

kmeans_grouping_layout[3,1] <- "Second Group (Channel)"
kmeans_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

## output params
kmeans_output_frame <- gframe(text = "KL Output Options",
                           horizontal = FALSE,
                           container = kmeans_param_frame,
                           expand = TRUE,
                           width = 300)

# apply kmeans button
kmeans_apply_btn <- gbutton("Apply KL to Data",
                         container = kmeans_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)
tool_output_name <- gedit(text = "Output.Variable",
                          container = kmeans_output_frame,
                          width = 25)

# save kmeans
kmeans_save_btn <- gfilebrowse(text = "Save Transformed Data",
                            type = "save",
                            container = kmeans_output_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # save file
                              
                              # update list to include
                              
                            })


# plot variances
kmeans_variance_btn <- gbutton("Plot Eigenvalues",
                            container = kmeans_output_frame)
kmeans_subspace_btn <- gbutton("Plot 2D Subspaces",
                            container = kmeans_output_frame)

# plot pane

# kmeans plot on right side
kmeans_plot_frame <- ggraphics(container = kmeans_action_pane)

# set some widths (doesn't work if earlier)
svalue(kmeans_pane) <- 0.2
svalue(kmeans_action_pane) <- 0.2
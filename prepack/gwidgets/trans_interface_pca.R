# button pane
pca_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = trans_pca_tab)


pca_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = pca_pane,
                            expand = TRUE,
                            width = 300)
# populate varlist
# TODO Update features spinbox on change
pca_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]),
  container = pca_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

pca_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = pca_pane)


## pca params
pca_param_frame <- gframe(text = "PCA Parameters",
                          horizontal = FALSE,
                          container = pca_action_pane,
                          expand = TRUE,
                          width = 300)

## opts
pca_kernel_type_list <- c("Linear","Gaussian","Laplace","Polynomial","Hyperbolic",
                          "Bessel","ANOVA")
pca_kernel_type_label <- glabel(text = "Kernel Type",
                                container = pca_param_frame)
pca_kernel_type_menu <- 
  gdroplist(pca_kernel_type_list,
            text = "Kernel Type",
            container = pca_param_frame,
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
                        enabled(pca_band_layout[1,1]) <- FALSE
                        enabled(pca_band_layout[2,1]) <- FALSE
                        enabled(pca_band_layout[1,2]) <- FALSE
                        enabled(pca_band_layout[2,2]) <- FALSE
                        enabled(pca_band_layout[3,1]) <- FALSE
                        enabled(pca_band_layout[4,1]) <- FALSE
                      },
                      "Laplace" = {
                        enabled(pca_band_layout[1,1]) <- TRUE
                        enabled(pca_band_layout[2,1]) <- TRUE
                        svalue(pca_band_layout[1,1]) <- "Sigma"
                        
                        enabled(pca_band_layout[1,2]) <- FALSE
                        enabled(pca_band_layout[2,2]) <- FALSE
                        enabled(pca_band_layout[3,1]) <- FALSE
                        enabled(pca_band_layout[4,1]) <- FALSE
                      },
                      "Gaussian" = {
                        enabled(pca_band_layout[1,1]) <- TRUE
                        enabled(pca_band_layout[2,1]) <- TRUE
                        svalue(pca_band_layout[1,1]) <- "Sigma"
                        
                        enabled(pca_band_layout[1,2]) <- FALSE
                        enabled(pca_band_layout[2,2]) <- FALSE
                        enabled(pca_band_layout[3,1]) <- FALSE
                        enabled(pca_band_layout[4,1]) <- FALSE
                      },
                      "Polynomial" = {
                        enabled(pca_band_layout[1,1]) <- TRUE
                        enabled(pca_band_layout[2,1]) <- TRUE
                        svalue(pca_band_layout[1,1]) <- "Degree"
                        
                        enabled(pca_band_layout[1,2]) <- TRUE
                        enabled(pca_band_layout[2,2]) <- TRUE
                        svalue(pca_band_layout[1,2]) <- "Scale"
                        
                        enabled(pca_band_layout[3,1]) <- TRUE
                        enabled(pca_band_layout[4,1]) <- TRUE
                        svalue(pca_band_layout[3,1]) <- "Offset"
                      },
                      "Hyperbolic" = {
                        enabled(pca_band_layout[1,1]) <- TRUE
                        enabled(pca_band_layout[2,1]) <- TRUE
                        svalue(pca_band_layout[1,1]) <- "Scale"
                        
                        enabled(pca_band_layout[1,2]) <- TRUE
                        enabled(pca_band_layout[2,2]) <- TRUE
                        svalue(pca_band_layout[1,2]) <- "Offset"
                        
                        enabled(pca_band_layout[3,1]) <- FALSE
                        enabled(pca_band_layout[4,1]) <- FALSE
                      },
                      "Bessel" = {
                        enabled(pca_band_layout[1,1]) <- TRUE
                        enabled(pca_band_layout[2,1]) <- TRUE
                        svalue(pca_band_layout[1,1]) <- "Sigma"
                        
                        enabled(pca_band_layout[1,2]) <- TRUE
                        enabled(pca_band_layout[2,2]) <- TRUE
                        svalue(pca_band_layout[1,2]) <- "Order"
                        
                        enabled(pca_band_layout[3,1]) <- TRUE
                        enabled(pca_band_layout[4,1]) <- TRUE
                        svalue(pca_band_layout[3,1]) <- "Degree"
                      },
                      "ANOVA" = {
                        enabled(pca_band_layout[1,1]) <- TRUE
                        enabled(pca_band_layout[2,1]) <- TRUE
                        svalue(pca_band_layout[1,1]) <- "Sigma"
                        
                        enabled(pca_band_layout[1,2]) <- TRUE
                        enabled(pca_band_layout[2,2]) <- TRUE
                        svalue(pca_band_layout[1,2]) <- "Degree"
                        
                        enabled(pca_band_layout[3,1]) <- FALSE
                        enabled(pca_band_layout[4,1]) <- FALSE
                      })
            })


# numerical entries (spinboxes)
pca_band_label <- glabel(text = "Numerical Parameters",
                         container = pca_param_frame)
pca_band_layout <- glayout(container = pca_param_frame)


pca_band_layout[1,1] <- ""
pca_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
pca_band_layout[1,2] <- ""
pca_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
pca_band_layout[3,1] <- ""
pca_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band end
pca_band_layout[3,2] <- "# of Features (0 = all)"
pca_band_layout[4,2] <- gspinbutton(from = 0, to = length(pca_varlist), by = 1)
enabled(pca_band_layout[1,1]) <- FALSE
enabled(pca_band_layout[2,1]) <- FALSE
enabled(pca_band_layout[1,2]) <- FALSE
enabled(pca_band_layout[2,2]) <- FALSE
enabled(pca_band_layout[3,1]) <- FALSE
enabled(pca_band_layout[4,1]) <- FALSE


## application params
pca_grouping_frame <- gframe(text = "Data Grouping",
                             horizontal = FALSE,
                             container = pca_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
pca_grouping_layout <- glayout(container = pca_grouping_frame)

pca_grouping_layout[1,1] <- "First Group (Trial)"
pca_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

pca_grouping_layout[3,1] <- "Second Group (Channel)"
pca_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

## output params
pca_output_frame <- gframe(text = "KL Output Options",
                           horizontal = FALSE,
                           container = pca_param_frame,
                           expand = TRUE,
                           width = 300)

# apply pca button
pca_apply_btn <- gbutton("Apply KL to Data",
                         container = pca_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)
tool_output_name <- gedit(text = "Output.Variable",
                          container = pca_output_frame,
                          width = 25)

# save pca
pca_save_btn <- gfilebrowse(text = "Save Transformed Data",
                            type = "save",
                            container = pca_output_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # save file
                              
                              # update list to include
                              
                            })


# plot variances
pca_variance_btn <- gbutton("Plot Eigenvalues",
                            container = pca_output_frame)
pca_subspace_btn <- gbutton("Plot 2D Subspaces",
                            container = pca_output_frame)

# plot pane

# pca plot on right side
pca_plot_frame <- ggraphics(container = pca_action_pane)

# set some widths (doesn't work if earlier)
svalue(pca_pane) <- 0.2
svalue(pca_action_pane) <- 0.2
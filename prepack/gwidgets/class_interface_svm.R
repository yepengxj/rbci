## button pane
svm_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = svm_tab)

svm_param_group <- ggroup(container = svm_pane,
                          horizontal = TRUE)

svm_varlist_frame <- gframe(text = "Feature Columns",
                            horizontal = FALSE,
                            container = svm_param_group,
                            expand = TRUE,
                            width = 300)
# populate varlist
svm_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
  container = svm_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

## svm params
svm_param_frame <- gframe(text = "SVM Parameters",
                          horizontal = FALSE,
                          container = svm_param_group,
                          expand = TRUE,
                          width = 300)

## opts
svm_kernel_type_list <- c("Linear", "Gaussian",
                          "Laplace", "Polynomial",
                          "Hyperbolic", "Bessel",
                          "ANOVA RBF", "Spline")
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
                      "Linear" = {
                        enabled(svm_band_layout[1,1]) <- FALSE
                        enabled(svm_band_layout[2,1]) <- FALSE
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Laplace" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Sigma"
                        
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Gaussian" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Sigma"
                        
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Polynomial" = {
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
                      "Hyperbolic" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Scale"
                        
                        enabled(svm_band_layout[1,2]) <- TRUE
                        enabled(svm_band_layout[2,2]) <- TRUE
                        svalue(svm_band_layout[1,2]) <- "Offset"
                        
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Bessel" = {
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
                      "ANOVA RBF" = {
                        enabled(svm_band_layout[1,1]) <- TRUE
                        enabled(svm_band_layout[2,1]) <- TRUE
                        svalue(svm_band_layout[1,1]) <- "Sigma"
                        
                        enabled(svm_band_layout[1,2]) <- TRUE
                        enabled(svm_band_layout[2,2]) <- TRUE
                        svalue(svm_band_layout[1,2]) <- "Degree"
                        
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      },
                      "Spline" = {
                        enabled(svm_band_layout[1,1]) <- FALSE
                        enabled(svm_band_layout[2,1]) <- FALSE
                        
                        enabled(svm_band_layout[1,2]) <- FALSE
                        enabled(svm_band_layout[2,2]) <- FALSE
                        
                        enabled(svm_band_layout[3,1]) <- FALSE
                        enabled(svm_band_layout[4,1]) <- FALSE
                      })
            })

## target variable
svm_target_label <- glabel("Target Variable",
                           container = svm_param_frame)

svm_target_list <-
    gcombobox(
        container = svm_param_frame,
        names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

## numerical entries (spinboxes)
svm_band_label <- glabel(text = "Numerical Parameters",
                         container = svm_param_frame)
svm_band_layout <- glayout(container = svm_param_frame)


svm_band_layout[1,1] <- ""
svm_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

svm_band_layout[1,2] <- ""
svm_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

svm_band_layout[3,1] <- ""
svm_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

svm_band_layout[3,2] <- "Cost"
svm_band_layout[4,2] <- gspinbutton(from = 0, to = length(svm_varlist), by = 1)
enabled(svm_band_layout[1,1]) <- FALSE
enabled(svm_band_layout[2,1]) <- FALSE
enabled(svm_band_layout[1,2]) <- FALSE
enabled(svm_band_layout[2,2]) <- FALSE
enabled(svm_band_layout[3,1]) <- FALSE
enabled(svm_band_layout[4,1]) <- FALSE


## application params
# training/test fractions

## output params
svm_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = svm_param_frame,
                           expand = TRUE)

svm_output_layout <- glayout(container = svm_output_frame)
# apply svm button
svm_output_layout[1,1] <-
    gbutton("Train Model",
            handler = function(h,...){
                train.name <- svalue(class_var_filesel)
                train.data <- rbci.env$importlist[[train.name]]
                svm.kern <- svalue(svm_kernel_type_menu)
                svm.target <- svalue(svm_target_list)
                svm.features <- svalue(svm_varlist)
                svm.cost <- svalue(svm_band_layout[4,2])
                svm.kernparams <- list(
                    svalue(svm_band_layout[2,1]),
                    svalue(svm_band_layout[2,2]),
                    svalue(svm_band_layout[4,1]))

                new.table <-
                    list(
                        train.svm.model(train.data,
                                        svm.kern,
                                        svm.target,
                                        svm.features,
                                        svm.cost,
                                        svm.lambda.var)
                        )
                
                names(new.table) <- paste(train.name,
                                          "svmmodel", seq_along(new.table),
                                          sep = ".")
                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

            })

svm_test_btn <- 
    gbutton("Test Model",
            container = svm_output_frame,
            handler = function(h,...){
                svm.name <- svalue(class_var_filesel)
                svm.model <- rbci.env$importlist[[svm.name]]
                test.dataname <- svalue(svm_test_list)
                test.data <- rbci.env$importlist[[test.dataname]]
                test.feats <- svalue(svm_varlist)
                
                new.table <-
                    test.svm.model(test.data,
                                   svm.model,
                                   test.feats)
                
                names(new.table) <- paste(test.dataname,
                                          "svmtest", seq_along(new.table),
                                          sep = ".")
                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

            })

svm_test_label <-
    glabel("Test Set",
           container = svm_output_frame,
           handler = function(h,...) {
               

           })

svm_test_list <-
    gdroplist(container = svm_output_frame,
              names(rbci.env$importlist))

### TODO refresh dataset frame on run
### TODO alert complete (progress bar?)

svm_output_layout[1,2] <- gbutton("Print Table")
svm_output_layout[2,1] <- gbutton("Print Model")
svm_output_layout[2,2] <- gbutton("Plot Model (Overview)")

# plot pane

# svm plot on right side
svm_plot_frame <- ggraphics(container = svm_pane)

# set some widths (doesn't work if earlier)
svalue(svm_pane) <- 0.5

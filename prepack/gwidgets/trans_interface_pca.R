# button pane
pca_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = trans_pca_tab)

## pca params
pca_param_frame <- gframe(text = "PCA Parameters",
                          horizontal = FALSE,
                          container = pca_pane,
                          expand = TRUE,
                          width = 300)

## opts
pca_kernel_type_list <- c("Linear","Gaussian","Laplace","Polynomial",
                          "Hyperbolic","Bessel","ANOVA")
pca_kernel_type_label <- glabel(text = "Kernel Type",
                                container = pca_param_frame)
pca_kernel_type_menu <- 
  gdroplist(pca_kernel_type_list,
            text = "Kernel Type",
            container = pca_param_frame,
            handler = function (h,...) {
                ## enable or disable param GUI opts on type change
                
                ## param names by type
                ## sigma for rbf/Laplace
                ## degree, scale, offset for Polynomial
                ## scale, offset for tanhdot
                ## sigma, order, degree, for Bessel
                ## sigma, degree for ANOVA
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
pca_band_layout[4,2] <-
    gspinbutton(
        from = 0, # TODO fix upper limit
        to = 300,
        by = 1)

enabled(pca_band_layout[1,1]) <- FALSE
enabled(pca_band_layout[2,1]) <- FALSE
enabled(pca_band_layout[1,2]) <- FALSE
enabled(pca_band_layout[2,2]) <- FALSE
enabled(pca_band_layout[3,1]) <- FALSE
enabled(pca_band_layout[4,1]) <- FALSE

addSpring(pca_param_frame)

## application params
pca_grouping_frame <- gframe(text = "Data Grouping",
                             horizontal = FALSE,
                             container = pca_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
pca_grouping_layout <- glayout(container = pca_grouping_frame)

pca_grouping_layout[1,1] <- "Data Variable (Voltage)"
pca_grouping_layout[2,1] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

pca_grouping_layout[1,2] <- "Time Variable (Sample)"
pca_grouping_layout[2,2] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

pca_grouping_layout[3,1] <- "Target Variable (Class)"
pca_grouping_layout[4,1] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

pca_grouping_layout[3,2] <- "Channel Variable"
pca_grouping_layout[4,2] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

pca_grouping_layout[5,1] <- "Epoch Group (Trial)"
pca_grouping_layout[6,1] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

### output params
pca_output_frame <- gframe(text = "PCA Output Options",
                           horizontal = FALSE,
                           container = pca_param_frame,
                           width = 300)

pca_output_layout <- glayout(container = pca_output_frame,
                             expand = TRUE)

## compute pca button
pca_output_layout[1,1] <-
    gbutton("Compute PCA",
#            container = pca_output_frame,
            handler = function(h,...){
                input.name <- svalue(trans_var_filesel)
                input.data <- rbci.env$importlist[[input.name]]
                input.val <- svalue(pca_grouping_layout[2,1])
                input.targ <- svalue(pca_grouping_layout[4,1])
                input.epoc <- svalue(pca_grouping_layout[6,1])
                input.time <- svalue(pca_grouping_layout[2,2])
                input.chan <- svalue(pca_grouping_layout[4,2])
                
                new.table <-
                    list(
                        transform.pca(targ.name = input.targ,
                                      epoch.name = input.epoc,
                                      time.name = input.time,
                                      input.table = input.data,
                                      split.col = input.chan,
                                      val.col = input.val,
                                      kernel.type = svalue(pca_kernel_type_menu),
                                      pc.count = svalue(pca_band_layout[4,2])))
                
                names(new.table) <- paste(input.name,
                                          "pcamodel", seq_along(new.table),
                                          sep = ".")
                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))
            })

## apply pca button
# refresh dataset frame on run
# alert complete (progress bar?)

# plot variances
pca_output_layout[1,2] <-
    gbutton("Plot Eigenvalues",
#            container = pca_output_frame,
            handler = function(h,...){
                
                pca.obj <- rbci.env$importlist[[svalue(trans_var_filesel)]]
                print(plot(pca.obj))
                
            })
pca_output_layout[2,2] <-
    gbutton("Plot 2D Subspaces",
#            container = pca_output_frame,
            handler = function(h,...){
### TODO add hex binning etc.
### see https://github.com/vqv/ggbiplot/blob/master/README.markdown
                pca.obj <- rbci.env$importlist[[svalue(trans_var_filesel)]]
                print(ggbiplot(pca.obj))
                
            })

pca_output_layout[2,1] <-
    gbutton("Transform Data Set (PC)",
#            container = pca_output_frame,
            handler = function(h,...){
                transform.file <- svalue(pca_output_layout[3,1])
                new.table <-
                    transform.pc(rbci.env$importlist[transform.file])
                
                names(new.table) <- paste(input.name,
                                          "pc", seq_along(new.table),
                                          sep = ".")
                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))
            })

pca_output_layout[3,1] <-
    gdroplist(names(rbci.env$importlist))
#              container = pca_output_frame)

# plot pane

# pca plot on right side
pca_plot_frame <- ggraphics(container = pca_pane)

# set some widths (doesn't work if earlier)
svalue(pca_pane) <- 0.4

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
kmeans_algorithm_type_list <- c("Hartigan-Wong","Lloyd-Forgy","MacQueen")
kmeans_algorithm_type_label <- glabel(text = "Algorithm",
                                      container = kmeans_param_frame)
kmeans_algorithm_type_menu <- 
  gdroplist(kmeans_algorithm_type_list,
            text = "Algorithm",
            container = kmeans_param_frame,
            handler = function (h,...) {
              # enable or disable param GUI opts on type change
              
#               switch (svalue(h$obj),
#                       "Hartigan-Wong" = {
# #                         enabled(kmeans_band_layout[1,1]) <- FALSE
# #                         enabled(kmeans_band_layout[2,1]) <- FALSE
# #                         enabled(kmeans_band_layout[1,2]) <- FALSE
# #                         enabled(kmeans_band_layout[2,2]) <- FALSE
#                       },
#                       "Lloyd-Forgy" = {
# #                         enabled(kmeans_band_layout[1,1]) <- TRUE
# #                         enabled(kmeans_band_layout[2,1]) <- TRUE
# #                         svalue(kmeans_band_layout[1,1]) <- "Sigma"
# #                         
# #                         enabled(kmeans_band_layout[1,2]) <- FALSE
# #                         enabled(kmeans_band_layout[2,2]) <- FALSE
#                       },
#                       "MacQueen" = {
# #                         enabled(kmeans_band_layout[1,1]) <- TRUE
# #                         enabled(kmeans_band_layout[2,1]) <- TRUE
# #                         svalue(kmeans_band_layout[1,1]) <- "Sigma"
# #                         
# #                         enabled(kmeans_band_layout[1,2]) <- FALSE
# #                         enabled(kmeans_band_layout[2,2]) <- FALSE
#                       })
            })


# numerical entries (spinboxes)
kmeans_band_label <- glabel(text = "Numerical Parameters",
                            container = kmeans_param_frame)
kmeans_band_layout <- glayout(container = kmeans_param_frame)


kmeans_band_layout[1,1] <- "# of Centers"
kmeans_band_layout[2,1] <- gspinbutton(from = 0, by = 1)


kmeans_band_layout[1,2] <- "Max. Iterations"
kmeans_band_layout[2,2] <- gspinbutton(from = 1, by = 1)

# kmeans_band_layout[3,1] <- ""
# kmeans_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)
# 
# kmeans_band_layout[3,2] <- "# of Features (0 = all)"
# kmeans_band_layout[4,2] <- gspinbutton(from = 0, to = length(kmeans_varlist), by = 1)

# enabled(kmeans_band_layout[1,1]) <- FALSE
# enabled(kmeans_band_layout[2,1]) <- FALSE
# enabled(kmeans_band_layout[1,2]) <- FALSE
# enabled(kmeans_band_layout[2,2]) <- FALSE


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
kmeans_output_frame <- gframe(text = "Cluster Output Options",
                              horizontal = FALSE,
                              container = kmeans_param_frame,
                              expand = TRUE,
                              width = 300)

## apply kmeans button
kmeans_apply_btn <-
    gbutton("Cluster Data",
            container = kmeans_output_frame,
            handler = function (h,...) {
                k.type <- svalue(kmeans_algorithm_type_menu)
                k.center <- svalue(kmeans_band_layout[2,1])
                k.iter <- svalue(kmeans_band_layout[2,2])
                k.groups <- c(svalue(k_means_grouping_layout[2,1]),
                              svalue(k_means_grouping_layout[4,1]))
                k.data <- svalue(trans_var_filesel)
                k.col <- svalue(kmeans_varlist_frame)
                
                ## do clustering, get model
                rbci.env$transformlist[paste(k.data,"kmeans",sep=".")] <-
                    transform.kmeans(k.data, k.col,
                                     k.type, k.center, k.iter, k.groups)
                ## no need to make list names unique here
            })

## refresh dataset frame on run
## alert complete

# tool_output_name <- gedit(text = "Output.Variable",
#                           container = kmeans_output_frame,
#                           width = 25)

## save kmeans
kmeans_save_btn <-
    gfilebrowse(text = "Save Cluster Data",
                type = "save",
                container = kmeans_output_frame,
                handler = function (h,...) {
                    
                    ## save file
                    save(rbci.env$transformlist[paste(k.data,"kmeans",sep=".")],
                         file = gfile(
                         filter = list("RData" = list(patterns = c("*.RData")))),
                         type = "save"))
                    
                })


## plot variances
kmeans_plot_btn <-
    gbutton("Plot Clustered Data",
            container = kmeans_output_frame,
            handler = function(h,...) {
                ## automatically selects kmeans plot from selected data
                ## TODO add error handling if no preexisting kmeans data
                plot(rbci.env$transformlist[paste(k.data,"kmeans",sep=".")])
                
            })

## plot pane

## kmeans plot on right side
kmeans_plot_frame <- ggraphics(container = kmeans_action_pane)

## set some widths (doesn't work if earlier)
svalue(kmeans_pane) <- 0.2
svalue(kmeans_action_pane) <- 0.2

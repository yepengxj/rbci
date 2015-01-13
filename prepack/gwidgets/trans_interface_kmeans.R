# button pane
kmeans_pane <- gpanedgroup(horizontal = TRUE,
                           expand = TRUE,
                           fill = TRUE,
                           container = trans_kmeans_tab)


kmeans_varlist_frame <- gframe(text = "Cluster Column",
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
                k.dataname <- svalue(trans_var_filesel)
                k.datafile <- rbci.env$importlist[[k.dataname]]
                k.col <- svalue(kmeans_varlist)
                
                ## do clustering, get model
                new.table <-
                    list(
                        transform.kmeans(k.datafile, k.col,
                                         k.type, k.center, k.iter)
##                                         k.trial, k.chan)
                        )
                names(new.table) <- paste(k.dataname,
                                          "kmeansmodel", seq_along(new.table),
                                          sep = ".")

                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))
            })

## refresh dataset frame on run
## alert complete

## plot variances
kmeans_plot_btn <-
    gbutton("Plot Clustered Data",
            container = kmeans_output_frame,
            handler = function(h,...) {
                k.dataname <- svalue(trans_var_filesel)
                k.datafile <- rbci.env$importlist[[k.dataname]]
                k.tgtname <- svalue(kmeans_data_list)
                k.tgtfile <- rbci.env$importlist[[k.tgtname]]
                
                print(clusplot(k.tgtfile, k.datafile$cluster,
                               color=TRUE, shade=TRUE, 
                               labels=2, lines=0))
                
            })

kmeans_plotsil_btn <-
    gbutton("Plot Silhouette",
            container = kmeans_output_frame,
            handler = function(h,...) {
                k.dataname <- svalue(trans_var_filesel)
                k.datafile <- rbci.env$importlist[[k.dataname]]
                k.tgtname <- svalue(kmeans_data_list)
                k.tgtfile <- rbci.env$importlist[[k.tgtname]]
                
                dissE <- daisy(k.tgtfile)
                sil <- silhouette(k.datafile$cluster, dissE)
                print(plot(sil))
            })


## cluster plot target data
kmeans_plotdata_label <- glabel("Plot Data Set")
kmeans_data_list <-
    gdroplist(names(rbci.env$importlist),
              container = kmeans_output_frame)

## plot pane

## kmeans plot on right side
kmeans_plot_frame <- ggraphics(container = kmeans_action_pane)

## set some widths (doesn't work if earlier)
svalue(kmeans_pane) <- 0.2
svalue(kmeans_action_pane) <- 0.2

# button pane
csp_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = trans_csp_tab)


csp_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = csp_pane,
                            expand = TRUE,
                            width = 300)

# populate varlist
csp_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]),
  container = csp_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

csp_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = csp_pane)


## csp params
csp_param_frame <- gframe(text = "CSP Parameters",
                             horizontal = FALSE,
                             container = csp_action_pane,
                             expand = TRUE,
                             width = 300)

## opts
csp_grouping_layout <- glayout(container = csp_param_frame)

csp_avg_type_list <- c("Arithmetic","Geometric","Harmonic")

csp_grouping_layout[1,1] <- "Average Type"
csp_grouping_layout[2,1] <- gdroplist(csp_avg_type_list,
                                      text = "Average Type")

csp_grouping_layout[1,2] <- "Time Variable (Sample)"
csp_grouping_layout[2,2] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

csp_grouping_layout[3,1] <- "Target Variable (Class)"
csp_grouping_layout[4,1] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

csp_grouping_layout[3,2] <- "Channel Variable"
csp_grouping_layout[4,2] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

csp_grouping_layout[5,1] <- "Epoch Group (Trial)"
csp_grouping_layout[6,1] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

csp_grouping_layout[5,2] <- "Data Variable (Voltage)"
csp_grouping_layout[6,2] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

csp_feat_num_label <- glabel(text = "# of Spatial Pairs (0 = all)",
                             container = csp_param_frame)
csp_feat_num <- gspinbutton(from = 0, to = 100, by = 1,
                            container = csp_param_frame)

## application params
csp_grouping_frame <- gframe(text = "Data Grouping",
                                horizontal = FALSE,
                                container = csp_param_frame,
                                expand = TRUE,
                                width = 300)

## output params
csp_output_frame <- gframe(text = "Output Options",
                              horizontal = FALSE,
                              container = csp_param_frame,
                              expand = TRUE,
                              width = 300)

## apply csp button
csp_apply_btn <-
    gbutton("Process Data",
            container = csp_output_frame,
            handler = function (h,...) {
                csp.name <- svalue(trans_var_filesel)
                csp.data <- rbci.env$importlist[[csp.name]]
                csp.timecol <- svalue(csp_grouping_layout[2,2])
                csp.chancol <- svalue(csp_grouping_layout[4,2])
                csp.valcol <- svalue(csp_grouping_layout[6,2])
                csp.trialcol <- svalue(csp_grouping_layout[6,1])
                csp.classcol <- svalue(csp_grouping_layout[4,1])
                csp.avgtype <- svalue(csp_grouping_layout[2,1])
                csp.paircount <- svalue(csp_feat_num)
                
                ## do csp calc, get model
                new.table <-
                    list(
                        transform.csp(table.data = csp.data,
                                      time.col = csp.timecol,
                                      chan.col = csp.chancol,
                                      val.col = csp.valcol,
                                      trial.col = csp.trialcol,
                                      class.col = csp.classcol,
                                      avg.type = csp.avgtype,
                                      pair.count = csp.paircount)
                        )
                names(new.table) <- paste(csp.name,
                                          "csp", seq_along(new.table),
                                          sep = ".")
                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

            })

## refresh dataset frame on run
## alert complete

# tool_output_name <- gedit(text = "Output.Variable",
#                           container = csp_output_frame,
#                           width = 25)



## plot variances
csp_plot_btn <-
    gbutton("Plot CSP (Biplot)",
            container = csp_output_frame,
            handler = function(h,...) {
                ## automatically selects csp plot from selected data
                ## TODO add error handling if no preexisting csp data
                plot(rbci.env$transformlist[paste(k.data,"csp",sep=".")])
                
            })

## plot pane

## csp plot on right side
csp_plot_frame <- ggraphics(container = csp_action_pane)

## set some widths (doesn't work if earlier)
svalue(csp_pane) <- 0.2
svalue(csp_action_pane) <- 0.2

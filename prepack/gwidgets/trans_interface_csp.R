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
csp_param_frame <- gframe(text = "csp Parameters",
                             horizontal = FALSE,
                             container = csp_action_pane,
                             expand = TRUE,
                             width = 300)

## opts
csp_avg_type_list <- c("Arithmetic","Geometric","Harmonic")
csp_avg_type_label <- glabel(text = "Average Type",
                             container = csp_param_frame)
csp_avg_type_menu <-
    gdroplist(csp_avg_type_list,
              text = "Average Type",
              container = csp_param_frame)

## application params
csp_grouping_frame <- gframe(text = "Data Grouping",
                                horizontal = FALSE,
                                container = csp_param_frame,
                                expand = TRUE,
                                width = 300)
# trial/group vars
csp_grouping_layout <- glayout(container = csp_grouping_frame)

csp_grouping_layout[1,1] <- "First Group (Trial)"
csp_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

csp_grouping_layout[3,1] <- "Second Group (Channel)"
csp_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

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
                groups <- c(svalue(csp_grouping_layout[2,1]),
                            svalue(csp_grouping_layout[4,1]))
                csp.data <- svalue(trans_var_filesel)
                csp.col <- svalue(csp_varlist_frame)
                csp.avg.type <- svalue(csp_avg_type_menu)
                
                ## do clustering, get model
                rbci.env$transformlist[paste(csp.data,"csp",sep=".")] <-
                    transform.csp(table.data = csp.data,
                                  val.col = csp.col,
                                  col.groups = groups,
                                  avg.type = csp.avg.type)
                ## no need to make list names unique here
            })

## refresh dataset frame on run
## alert complete

# tool_output_name <- gedit(text = "Output.Variable",
#                           container = csp_output_frame,
#                           width = 25)

## save csp
csp_save_btn <-
    gfilebrowse(text = "Save CSP Data",
                type = "save",
                container = csp_output_frame,
                handler = function (h,...) {
                    csp.data <- svalue(trans_var_filesel)
                    
                    ## save file
                    save(rbci.env$transformlist[paste(csp.data,"csp",sep=".")],
                         file = gfile(
                         filter = list("RData" = list(patterns = c("*.RData")))),
                         type = "save")
                    
                })


## plot variances
csp_plot_btn <-
    gbutton("Plot Clustered Data",
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

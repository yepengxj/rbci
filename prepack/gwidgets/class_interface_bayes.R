# button pane
bayes_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = bayes_tab)


bayes_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = bayes_pane,
                            expand = TRUE,
                            width = 300)
# populate varlist
# TODO Update features spinbox on change
bayes_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
  container = bayes_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

bayes_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = bayes_pane)


## bayes params
bayes_param_frame <- gframe(text = "Naive Bayes Parameters",
                          horizontal = FALSE,
                          container = bayes_action_pane,
                          expand = TRUE,
                          width = 300)

## opts

# numerical entries (spinboxes)
bayes_band_label <- glabel(text = "Numerical Parameters",
                         container = bayes_param_frame)
bayes_band_layout <- glayout(container = bayes_param_frame)


bayes_band_layout[1,1] <- "Laplace smoothing"
bayes_band_layout[2,1] <- gspinbutton(from = 0, by = 0.01)

# # stop band end
# bayes_band_layout[1,2] <- "Shrinkage (variances)"
# bayes_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)
# 
# # pass band start
# bayes_band_layout[3,1] <- "Shrinkage (frequencies)"
# bayes_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)


## application params
bayes_grouping_frame <- gframe(text = "Data Grouping",
                             horizontal = FALSE,
                             container = bayes_param_frame,
                             expand = FALSE)

# trial/group vars
bayes_grouping_layout <- glayout(container = bayes_grouping_frame)

bayes_grouping_layout[1,1] <- "First Group (Trial)"
bayes_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

bayes_grouping_layout[3,1] <- "Second Group (Channel)"
bayes_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

## output params
bayes_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = bayes_param_frame,
                           expand = TRUE,
                           width = 300)

bayes_output_layout <- glayout(container = bayes_output_frame)
# apply bayes button
bayes_output_layout[1,1] <-
    gbutton("Train",
            handler = function(h,...){
                
            })
bayes_output_layout[1,2] <-
    gbutton("Test",
            handler = function(h,...){
                
            })

## refresh dataset frame on run
## alert complete (progress bar?)

### save bayes
bayes_output_layout[2,1] <-
    gbutton(text = "Export Model",
            handler = function (h,...) {
                
                ## save file
                ## update list to include
                save(output.model, ## TODO need to organize this
                     file = gfile(
                         filter = list("RData"= list(patterns = c("*.RData"))),
                         type = "save"))
                
            })


bayes_output_layout[2,2] <- gbutton("Print Table")
bayes_output_layout[3,1] <- gbutton("Print Model")

bayes_output_frame <- gtext(text = "bayes output",
                          font.attr=c(family="monospace"),
                          width = window.width*0.4,
                          container = bayes_pane)

# set some widths (doesn't work if earlier)
svalue(bayes_pane) <- 0.2

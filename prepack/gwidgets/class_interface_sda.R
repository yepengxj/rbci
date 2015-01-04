# button pane
sda_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = sda_tab)


sda_varlist_frame <- gframe(text = "Apply Columns",
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
sda_param_frame <- gframe(text = "SDA Parameters",
                          horizontal = FALSE,
                          container = sda_action_pane,
                          expand = TRUE,
                          width = 300)

## opts

# numerical entries (spinboxes)
sda_band_label <- glabel(text = "Numerical Parameters",
                         container = sda_param_frame)
sda_band_layout <- glayout(container = sda_param_frame)


sda_band_layout[1,1] <- "Shrinkage (correlation matrix)"
sda_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
sda_band_layout[3,1] <- "Shrinkage (variances)"
sda_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
sda_band_layout[5,1] <- "Shrinkage (frequencies)"
sda_band_layout[6,1] <- gspinbutton(from = 0, to = 1, by = 0.01)


## application params
sda_grouping_frame <- gframe(text = "Data Grouping",
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
sda_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = sda_param_frame,
                           expand = TRUE,
                           width = 300)

sda_output_layout <- glayout(container = sda_output_frame)
# apply sda button
sda_output_layout[1,1] <-
    gbutton("Train",
            handler = function(h,...){
                
            })
sda_output_layout[1,2] <-
    gbutton("Test",
            handler = function(h,...){
                
            })

## refresh dataset frame on run
## alert complete (progress bar?)

### save sda
sda_output_layout[2,1] <-
    gbutton(text = "Export Model",
            handler = function (h,...) {
                
                ## save file
                ## update list to include
                save(output.model, ## TODO need to organize this
                     file = gfile(
                         filter = list("RData"= list(patterns = c("*.RData"))),
                         type = "save"))
                
            })


sda_output_layout[2,2] <- gbutton("Print Table")
sda_output_layout[3,1] <- gbutton("Print Model")

sda_output_frame <- gtext(text = "sda output",
                           font.attr=c(family="monospace"),
                           width = window.width*0.4,
                           container = sda_pane)

# set some widths (doesn't work if earlier)
svalue(sda_pane) <- 0.2

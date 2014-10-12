# button pane
simple_pane <- gpanedgroup(horizontal = TRUE,
                           expand = TRUE,
                           fill = TRUE,
                           container = filter_simple_tab)


filter_varlist_frame <- gframe(text = "Data Columns",
                               horizontal = FALSE,
                               container = simple_pane,
                               expand = TRUE,
                               width = 300)
# populate varlist
filter_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(filter_var_filesel, index=TRUE)]]),
  container = filter_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

simple_filter_pane <- gpanedgroup(horizontal = TRUE,
                                  expand = TRUE,
                                  fill = TRUE,
                                  container = simple_pane)


## filter params
filter_param_frame <- gframe(text = "Filter Parameters",
                             horizontal = FALSE,
                             container = simple_filter_pane,
                             expand = TRUE,
                             width = 300)

# type
filter_type_list <- c("Lowpass","Bandpass","Highpass","Stopband")
filter_type_label <- glabel(text = "Filter Type",
                            container = filter_param_frame)
filter_type_menu <- 
  gdroplist(filter_type_list,
            text = "Filter Type",
            container = filter_param_frame,
            handler = function (h,...) {
              # enable or disable band param GUI opts on type change
           })

# band entry (spinboxes)
filter_band_label <- glabel(text = "Filter Band",
                            container = filter_param_frame)
filter_band_layout <- glayout(container = filter_param_frame)

# stop band start
filter_band_layout[1,1] <- "Stopband Start"
filter_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)
  
# stop band end
filter_band_layout[1,2] <- "Stopband End"
filter_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
filter_band_layout[3,1] <- "Passband Start"
filter_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band end
filter_band_layout[3,2] <- "Passband End"
filter_band_layout[4,2] <- gspinbutton(from = 0, to = 1, by = 0.01)


## application params
filter_grouping_frame <- gframe(text = "Filter Apply Rules",
                             horizontal = FALSE,
                             container = filter_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
filter_grouping_label <- glabel(text = "Data Grouping",
                                container = filter_grouping_frame)
filter_grouping_layout <- glayout(container = filter_grouping_frame)

filter_grouping_layout[1,1] <- "First Group (Trial)"
filter_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(filter_var_filesel, index=TRUE)]]))

filter_grouping_layout[3,1] <- "Second Group (Channel)"
filter_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(filter_var_filesel, index=TRUE)]]))

## output params
filter_output_frame <- gframe(text = "Filter Output Options",
                                horizontal = FALSE,
                                container = filter_param_frame,
                                expand = TRUE,
                                width = 300)

# apply filter button
filter_apply_btn <- gbutton("Apply Filter Data",
                            container = filter_output_frame)

# save filter
filter_save_btn <- gbutton("Save Filtered Data",
                           container = filter_output_frame)
# refresh dataset frame on run

# plot pane

# filter plot on right side
filter_plot_frame <- ggraphics(container = simple_filter_pane)

# set some widths (doesn't work if earlier)
svalue(filter_param_frame) <- 0.2
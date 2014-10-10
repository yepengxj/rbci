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

filter_param_frame <- gframe(text = "Filter Parameters",
                             horizontal = FALSE,
                             container = simple_pane,
                             expand = TRUE,
                             width = 300)

## filter params

# type
filter_type_list <- c("Lowpass","Bandpass","Highpass","Stopband")
filter_type_menu <- 
  gdroplist(filter_type_list,
            handler = function (h,...) {
              # enable or disable band param GUI opts on type change
           })

# band entry (spinboxes)

## application params

# trial/group vars

## output params

# save filter

# apply filter button

# refresh dataset frame on run

# plot pane

# filter plot on right side
filter_plot_frame <- ggraphics(container = simple_filter_pane)

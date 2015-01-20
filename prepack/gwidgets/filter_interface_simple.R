# button pane
simple_pane <- gpanedgroup(horizontal = TRUE,
                           expand = TRUE,
                           fill = TRUE,
                           container = filter_simple_tab)


filter_varlist_frame <- gframe(text = "Apply Columns",
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
filter_band_label <- glabel(text = "Filter Band (Hz)",
                            container = filter_param_frame)
filter_band_layout <- glayout(container = filter_param_frame)

# stop band start
filter_band_layout[1,1] <- "Start"
filter_band_layout[2,1] <- gspinbutton(from = 0, to = 4096, by = 0.01)
  
# stop band end
filter_band_layout[1,2] <- "End"
filter_band_layout[2,2] <- gspinbutton(from = 0, to = 4096, by = 0.01)

filter_band_layout[3,1] <- "Sampling Rate (Hz)"
filter_band_layout[3,2] <- gspinbutton(from = 0.01, to = 4096, by = 0.01)

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
addSpring(filter_output_frame)
# apply filter button
filter_apply_btn <-
    gbutton("Apply Filter to Data",
            container = filter_output_frame,
            handler = function(h,...){
### TODO error checking on filt vals
                
                filt.type <- svalue(filter_type_menu)
                filt.band <- c(svalue(filter_band_layout[2,1]),
                                   svalue(filter_band_layout[2,2]))
                filt.groups <- c(svalue(filter_grouping_layout[2,1]),
                                 svalue(filter_grouping_layout[4,1]))
                file.name <- svalue(filter_var_filesel)
                filt.file <- rbci.env$importlist[[file.name]]
                filt.srate <- svalue(filter_band_layout[3,2])
                
                ## get the designed filter
                rbci.env$filter <- simple.filter(filt.type,
                                                 filt.band/0.2/(filt.srate/2),
                                                 filt.groups)
                
                ## plot the filter as confirmation that it worked
                visible(filter_plot_frame,TRUE)
                print(plot.filter(rbci.env$filter,
                                  sample.rate = filt.srate))
                
                ## apply the filter, add new data file to list
                new.table <- list(apply.filter(
                               signal.table = filt.file,
                               filt.groups = filt.groups,
                               val.col = svalue(filter_varlist),
                               filter.obj = rbci.env$filter))
                names(new.table) <- paste(file.name,
                                           "filt", seq_along(new.table),
                                           sep = ".")
                
                rbci.env$importlist <-
                    append(rbci.env$importlist, new.table)
                           
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))
            })

## refresh dataset frame on run
## alert complete (progress bar?)


## plot pane
# filter plot on right side
filter_plot_frame <- ggraphics(container = simple_filter_pane)

# set some widths (doesn't work if earlier)
svalue(filter_param_frame) <- 0.2

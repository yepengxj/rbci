downsample_varlist_frame <- gframe(text = "Data Columns",
                               horizontal = FALSE,
                               container = filter_downsample_tab,
                               expand = TRUE,
                               width = 300)
# populate varlist
downsample_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(filter_var_filesel, index=TRUE)]]),
  container = downsample_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

addHandlerChanged(filter_var_filesel,
                  handler = function(h,...) {
                      new.dataset.names <- 
                          names(rbci.env$importlist[[svalue(filter_var_filesel,
                                                            index=TRUE)]])
                      downsample_varlist[] <- new.dataset.names
                  })


## downsample params
downsample_param_frame <- gframe(text = "Downsample Parameters",
                             horizontal = FALSE,
                             container = filter_downsample_tab,
                             expand = TRUE,
                             width = 300)

### type
## downsample_type_list <- c("Lowpass","Bandpass","Highpass","Stopband")
## downsample_type_label <- glabel(text = "Downsample Type",
##                            container = downsample_param_frame)
# downsample_type_menu <- 
#   gdroplist(downsample_type_list,
#             text = "Downsample Type",
#             container = downsample_param_frame,
#             handler = function (h,...) {
#               # enable or disable band param GUI opts on type change
#            })

### numerical entry (spinboxes)
downsample_band_label <- glabel(text = "Numerical Parameters",
                            container = downsample_param_frame)
downsample_band_layout <- glayout(container = downsample_param_frame)

## sampling factor
downsample_band_layout[1,1] <- "Downsampling Factor"
downsample_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.001)

addSpring(downsample_param_frame)
## stop band end
## downsample_band_layout[1,2] <- "End"
## downsample_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

## application params
# downsample_grouping_frame <- gframe(text = "Sampling Apply Rules",
#                              horizontal = FALSE,
#                              container = downsample_param_frame,
#                              expand = TRUE,
#                              width = 300)
## trial/group vars
# downsample_grouping_label <- glabel(text = "Data Grouping",
#                                 container = downsample_grouping_frame)
# downsample_grouping_layout <- glayout(container = downsample_grouping_frame)
# 
# downsample_grouping_layout[1,1] <- "First Group (Trial)"
# downsample_grouping_layout[2,1] <- 
#     gcombobox(
#         names(rbci.env$importlist[[svalue(filter_var_filesel, index=TRUE)]]))
# 
# downsample_grouping_layout[3,1] <- "Second Group (Channel)"
# downsample_grouping_layout[4,1] <- 
#     gcombobox(
#         names(rbci.env$importlist[[svalue(filter_var_filesel, index=TRUE)]]))

## output params
downsample_output_frame <- gframe(text = "Output Options",
                                  horizontal = FALSE,
                                  container = downsample_param_frame,
                                  expand = FALSE,
                                  width = 320)

# apply downsample button
downsample_apply_btn <-
    gbutton("Apply Downsample to Data",
            container = downsample_output_frame,
            handler = function(h,...){
                ds.factor <- svalue(downsample_band_layout[2,1])
                ds.filename <- svalue(filter_var_filesel)
                ds.file <- rbci.env$importlist[[ds.filename]]
                ds.col <- svalue(downsample_varlist)

                new.table <-
                    list(downsample.dt(ds.file,ds.col,ds.factor))
                names(new.table) <- paste(ds.filename,
                                          "downsample", seq_along(new.table),
                                          sep = ".")
                ## apply the downsample, add new data file to list
                rbci.env$importlist <-
                    append(rbci.env$importlist,
                           new.table)
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))
            })

addHandlerClicked(downsample_apply_btn,
                  handler = function(h,...){
                      new.datasets <-
                          names(rbci.env$importlist)
                      filter_var_filesel[] <- new.datasets
                  })

# save downsample
# downsample_save_btn <- gbutton("Save Downsampled Data",
#                           container = downsample_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)

# set some widths (doesn't work if earlier)
svalue(downsample_param_frame) <- 0.2

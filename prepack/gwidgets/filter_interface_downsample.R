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
                ds.filename <- svalue(filter_var_filesel)

                ## collect args
                this.args <- list(
                    input.table = bquote( # partial dereference
                        rbci.env$importlist[[.(ds.filename)]]),
                    ds.factor = svalue(downsample_band_layout[2,1]),
                    time.col = svalue(downsample_varlist)
                )
                ## apply the downsample, add new data file to list
                new.table <- 
                    list(do.call(downsample.dt,this.args))
                
                names(new.table) <- paste(ds.filename,
                                          "downsample", seq_along(new.table),
                                          sep = ".")
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

                ## add op to reporter
                add.step("downsample.dt", this.args)
                
            })

# refresh dataset frame on run
addHandlerClicked(downsample_apply_btn,
                  handler = function(h,...){
                      new.datasets <-
                          names(rbci.env$importlist)
                      filter_var_filesel[] <- new.datasets
                  })

# alert complete (progress bar?)

# set some widths (doesn't work if earlier)
svalue(downsample_param_frame) <- 0.2

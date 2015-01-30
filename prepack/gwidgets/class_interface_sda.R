# button pane
sda_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = sda_tab)

sda_param_group <- ggroup(container = sda_pane,
                          horizontal = TRUE)

sda_varlist_frame <- gframe(text = "Feature Columns",
                            horizontal = TRUE,
                            container = sda_param_group,
                            expand = TRUE,
                            width = 300)

## populate varlist
sda_varlist <- gcheckboxgroup(
    names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
    container = sda_varlist_frame,
    use.table = TRUE,
    expand = TRUE)

## if we change datasets, update interface elements
addHandlerChanged(class_var_filesel,
                  handler = function(h,...) {
                      new.dataset.names <- 
                          names(rbci.env$importlist[[svalue(class_var_filesel)]])
                      sda_varlist[] <- new.dataset.names
                      sda_target_list[] <- new.dataset.names
                      
                  })


## sda params
sda_param_frame <- gframe(text = "SDA Parameters",
                          horizontal = FALSE,
                          container = sda_param_group,
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

## application params
sda_target_frame <- gframe(text = "Target Variable",
                           horizontal = FALSE,
                           container = sda_param_frame)

sda_target_list <-
    gcombobox(
        container = sda_target_frame,
        names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

## output params
sda_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = sda_param_frame,
                           width = 300)

sda_output_layout <- glayout(container = sda_output_frame)
# apply sda button
sda_output_layout[1,1] <-
    gbutton("Train Model",
            handler = function(h,...){
                train.name <- svalue(class_var_filesel)

                train.args <- list(
                    train.data = bquote( # partial deref of dataset call
                        rbci.env$importlist[[.(train.name)]]),
                    target.col = svalue(sda_target_list),
                    feature.cols = svalue(sda_varlist),
                    sda.lambda = svalue(sda_band_layout[2,1]),
                    sda.lambda.var = svalue(sda_band_layout[4,1])
                )
                    
                new.table <- # do the train model call
                    list(do.call(train.sda.model,train.args))
                names(new.table) <- paste(train.name,
                                          "sdamodel", seq_along(new.table),
                                          sep = ".")                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)                
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

                ## update reporter with op
                add.step("train.sda.model", train.args)
            })

## refresh dataset frame on run
## alert complete (progress bar?)

sda_output_layout[1,2] <-
    gbutton("Print Table",
            handler = function(h,...) {
                sda.name <- svalue(class_var_filesel)
                data.name <- svalue(sda_test_list)
                target.col <- svalue(sda_target_list)

                table.args <- list( # collect table arguments
                    sda.prediction = bquote( # partially deref data calls
                        rbci.env$importlist[[.(sda.name)]]),
                    test.data =
                        bquote(
                            rbci.env$importlist[[.(data.name)]][,.(target.col),
                                                                with=FALSE])
                )

                ## send table to widget
                svalue(sda_output_frame) <-
                    capture.output(do.call(table.sda.model, table.args))

                ## send op to reporter
                add.step("table.sda.model", this.args)

            })

sda_output_layout[1,3] <-
    gbutton("Print Model",
            handler = function(h,...){
                sda.name <- svalue(class_var_filesel)
                print.args <- list(
                    x = bquote(
                        rbci.env$importlist[[.(sda.name)]])
                )

                svalue(sda_output_frame) <-
                    capture.output(
                        do.call(print, print.args)
                        )
                add.step("print", print.args)
                
            })

sda_test_btn <-
    gbutton("Test Model",
            container = sda_output_frame,
            handler = function(h,...){
                test.name <- svalue(class_var_filesel)
                test.dataname <- svalue(sda_test_list)

                ## collect args
                test.args <- list( 
                    sda.model = bquote(
                        rbci.env$importlist[[.(test.name)]]),
                    test.data = bquote(
                        rbci.env$importlist[[.(test.dataname)]]),
                    feature.cols = svalue(sda_varlist)
                )

                
                ## do work, update GUI
                new.table <- 
                    list(do.call(test.sda.model, test.args))
                names(new.table) <- paste(test.dataname,
                                          "sdatest", seq_along(new.table),
                                          sep = ".")
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

                ## add op to reporter
                add.step("test.sda.model", test.args)
            })

sda_test_label <- glabel("Test Set",
                         container = sda_output_frame)
sda_test_list <-
    gdroplist(container = sda_output_frame,
              names(rbci.env$importlist))

## we ALSO want to have column selector change when selecting target sets for
## the target set list
addHandlerChanged(sda_test_list,
                  handler = function(h,...) {
                      new.dataset.names <- 
                          names(rbci.env$importlist[[svalue(sda_test_list)]])

                      if (!is.null(new.dataset.names)) {
                          sda_varlist[] <- new.dataset.names
                          sda_target_list[] <- new.dataset.names
                      }
                  })

## Buttons that add new things should refresh the dataset selector
addHandlerClicked(sda_output_layout[1,1],
                  handler = function(h,...){
                      new.datasets <-
                          names(rbci.env$importlist)
                      class_var_filesel[] <- new.datasets
                      sda_test_list[] <- new.datasets
                  })
addHandlerClicked(sda_test_btn,
                  handler = function(h,...){
                      new.datasets <-
                          names(rbci.env$importlist)

                      sda_test_list[] <- new.datasets
                  })


sda_output_frame <- gtext(text = "sda output",
                           font.attr=c(family="monospace"),
#                           width = window.width*0.4,
                           container = sda_pane)

# set some widths (doesn't work if earlier)
svalue(sda_pane) <- 0.6

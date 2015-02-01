# button pane
bayes_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = bayes_tab)

bayes_param_group <- ggroup(container = bayes_pane,
                          horizontal = TRUE)

bayes_varlist_frame <- gframe(text = "Feature Columns",
                            horizontal = FALSE,
                            container = bayes_param_group,
                            expand = TRUE,
                            width = 300)
## populate varlist
bayes_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
  container = bayes_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

## if we change datasets, update interface elements
addHandlerChanged(class_var_filesel,
                  handler = function(h,...) {
                      new.dataset.names <- 
                          names(rbci.env$importlist[[svalue(class_var_filesel,
                                                            index=TRUE)]])
                      bayes_varlist[] <- new.dataset.names
                      bayes_target_list[] <- new.dataset.names
                      
                  })

## bayes params
bayes_param_frame <- gframe(text = "Naive Bayes Parameters",
                          horizontal = FALSE,
                          container = bayes_param_group,
                          expand = TRUE,
                          width = 300)

## opts

# numerical entries (spinboxes)
bayes_band_label <- glabel(text = "Numerical Parameters",
                         container = bayes_param_frame)
bayes_band_layout <- glayout(container = bayes_param_frame)


bayes_band_layout[1,1] <- "Laplace smoothing"
bayes_band_layout[2,1] <- gspinbutton(from = 0, by = 0.01)

## application params
bayes_target_frame <- gframe(text = "Target Variable",
                             horizontal = FALSE,
                             container = bayes_param_frame)

bayes_target_list <- 
    gcombobox(
        container = bayes_target_frame,
        names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]))

## output params
bayes_output_frame <- gframe(text = "Output Options",
                           horizontal = FALSE,
                           container = bayes_param_frame,
                           expand = TRUE,
                           width = 300)

bayes_output_layout <- glayout(container = bayes_output_frame)

## apply bayes button
bayes_output_layout[1,1] <-
    gbutton("Train Model",
            handler = function(h,...){
                train.name <- svalue(class_var_filesel)

                this.args <- list( # collect args
                    train.data = bquote( # partial deref
                        rbci.env$importlist[[.(train.name)]]),
                    bayes.smooth = svalue(bayes_band_layout[2,1]),
                    target.col = svalue(bayes_target_list),
                    feature.cols = svalue(bayes_varlist)
                )

                ## do the train model call
                new.table <- list(do.call(train.bayes.model,this.args))
                names(new.table) <- paste(train.name,
                                          "bayesmodel", seq_along(new.table),
                                          sep = ".")
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

                ## update reporter with op
                add.step("train.bayes.model", this.args)
                
            })

## refresh dataset frame on run
## alert complete (progress bar?)

bayes_output_layout[1,2] <-
    gbutton("Print Table",
            handler = function(h,...){
                bayes.name <- svalue(class_var_filesel)
                data.name <- svalue(bayes_test_list)
                target.col <- svalue(bayes_target_list)

                this.args <- list( # collect args
                    # partial deref
                    bayes.prediction =
                        bquote(rbci.env$importlist[[.(bayes.name)]]),
                    test.data = bquote(c(
                        rbci.env$importlist[[.(data.name)]][,.(target.col),
                                                            with=FALSE])[[1]]
                                       )
                )
                
                ## send table to widget
                svalue(bayes_output_frame) <-
                    ## we have to capture output here due to GUI
                    capture.output(do.call(table.bayes.model, this.args))

                ## send op to reporter
                add.step("table.bayes.model", this.args)
            })

bayes_output_layout[1,3] <-
    gbutton("Print Model",
            handler = function(h,...){
                bayes.name <- svalue(class_var_filesel)
                print.args <- list(
                    x = bquote(
                        rbci.env$importlist[[.(bayes.name)]])
                )

                svalue(bayes_output_frame) <-
                    capture.output(
                        do.call(print, print.args)
                    )

                add.step("print", print.args)
            })

bayes_test_btn <-
    gbutton("Test Model",
            container = bayes_output_frame,
            handler = function(h,...) {
                test.name <- svalue(class_var_filesel)
                test.dataname <- svalue(bayes_test_list)
                test.feats <- svalue(bayes_varlist)

                test.args <- list( # collect partially dereferenced args
                    bayes.model = bquote(
                        rbci.env$importlist[[.(test.name)]]),
                    test.data = bquote(
                        rbci.env$importlist[[.(test.dataname)]])
                )

                ## do work, update GUI
                new.table <- list(
                    # do the model test with the above args
                    do.call(test.bayes.model, test.args)
                    )
                names(new.table) <- paste(test.dataname,
                                          "bayestest", seq_along(new.table),
                                          sep = ".")
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

                ## add op to reporter
                add.step("test.bayes.model", test.args)
            })

bayes_test_label <- glabel("Test Set",
                         container = bayes_output_frame)
bayes_test_list <-
    gdroplist(container = bayes_output_frame,
              names(rbci.env$importlist))
## we ALSO want to have column selector change when selecting target sets for
## the target set list
addHandlerChanged(bayes_test_list,
                  handler = function(h,...) {
                      new.dataset.names <- 
                          names(rbci.env$importlist[[svalue(bayes_test_list)]])

                      if (!is.null(new.dataset.names)) {
                          bayes_varlist[] <- new.dataset.names
                          bayes_target_list[] <- new.dataset.names
                      }
                      
                  })

## Buttons that add new things should refresh the dataset selector
addHandlerClicked(bayes_output_layout[1,1],
                  handler = function(h,...){
                      new.datasets <-
                          names(rbci.env$importlist)
                      class_var_filesel[] <- new.datasets
                  })
addHandlerClicked(bayes_test_btn,
                  handler = function(h,...){
                      
                      bayes_test_list[] <-
                          names(rbci.env$importlist)
                  })


bayes_output_frame <- gtext(text = "bayes output",
                          font.attr=c(family="monospace"),
                          width = window.width*0.4,
                          container = bayes_pane)

# set some widths (doesn't work if earlier)
svalue(bayes_pane) <- 0.6

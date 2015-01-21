# button pane
bayes_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = bayes_tab)

bayes_param_group <- ggroup(container = bayes_pane,
                          horizontal = TRUE)

bayes_varlist_frame <- gframe(text = "Apply Columns",
                            horizontal = FALSE,
                            container = bayes_param_group,
                            expand = TRUE,
                            width = 300)
# populate varlist
# TODO Update features spinbox on change
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

# # stop band end
# bayes_band_layout[1,2] <- "Shrinkage (variances)"
# bayes_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)
# 
# # pass band start
# bayes_band_layout[3,1] <- "Shrinkage (frequencies)"
# bayes_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)


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
# apply bayes button
bayes_output_layout[1,1] <-
    gbutton("Train Model",
            handler = function(h,...){
                train.name <- svalue(class_var_filesel)
                train.data <- rbci.env$importlist[[train.name]]
                bayes.target <- svalue(bayes_target_list)
                bayes.features <- svalue(bayes_varlist)
                bayes.smooth <- svalue(bayes_band_layout[2,1])

                new.table <-
                    list(
                        train.bayes.model(train.data,
                                          bayes.smooth,
                                          bayes.target,
                                          bayes.features)
                        )
                
                names(new.table) <- paste(train.name,
                                          "bayesmodel", seq_along(new.table),
                                          sep = ".")
                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))
                
            })

## refresh dataset frame on run
## alert complete (progress bar?)

bayes_output_layout[1,2] <-
    gbutton("Print Table",
            handler = function(h,...){
                bayes.name <- svalue(class_var_filesel)
                bayes.pred <- rbci.env$importlist[[bayes.name]]
                data.name <- svalue(bayes_test_list)
                target.col <- svalue(bayes_target_list)
                data.actual <-
                    rbci.env$importlist[[data.name]][,target.col,with=FALSE]
                
                ## send table to widget
                svalue(bayes_output_frame) <-
                    capture.output(
                        table(predicted = bayes.pred,
                              data = data.actual[[target.col]])
                        )
                return()
            })

bayes_output_layout[1,3] <-
    gbutton("Print Model",
            handler = function(h,...){
                bayes.name <- svalue(class_var_filesel)
                bayes.model <- rbci.env$importlist[[bayes.name]]
                
                svalue(bayes_output_frame) <-
                    capture.output(
                        print(bayes.model)
                        )
            })

bayes_test_btn <-
    gbutton("Test Model",
            container = bayes_output_frame,
            handler = function(h,...){
                test.name <- svalue(class_var_filesel)
                test.model <- rbci.env$importlist[[test.name]]
                test.dataname <- svalue(bayes_test_list)
                test.data <- rbci.env$importlist[[test.dataname]]
                test.feats <- svalue(bayes_varlist)
                
                new.table <-
                    list(
                        test.bayes.model(test.model,
                                       test.data)
                                       # test.feats)
                        )
                
                names(new.table) <- paste(test.dataname,
                                          "bayestest", seq_along(new.table),
                                          sep = ".")
                
                rbci.env$importlist <- append(rbci.env$importlist,
                                              new.table)
                
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))

            })

bayes_test_label <- glabel("Test Set",
                         container = bayes_output_frame)
bayes_test_list <-
    gdroplist(container = bayes_output_frame,
              names(rbci.env$importlist))


bayes_output_frame <- gtext(text = "bayes output",
                          font.attr=c(family="monospace"),
                          width = window.width*0.4,
                          container = bayes_pane)

# set some widths (doesn't work if earlier)
svalue(bayes_pane) <- 0.6

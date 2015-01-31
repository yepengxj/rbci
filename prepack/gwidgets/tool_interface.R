window.width <- 1000
window.height <- 600

tool_win <- gwindow("Tool Designer",
                       width = window.width,
                       height = window.height)

tool_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = tool_win)


tool_var_group <- ggroup(use.scrollwindow = TRUE,
                            horizontal = FALSE,
                            expand = TRUE, 
                            container=tool_pane,
                            width = 200)
tool_var_frame <- gframe(text = "Scripts",
                            horizontal = FALSE,
                            container = tool_var_group,
                            expand = TRUE)

tool_edit_frame <- ggroup(text = "Editor",
                          container = tool_pane,
                          use.scrollwindow = FALSE,
                          horizontal = FALSE,
                          expand = TRUE)


tool_edit_text <- gtext(text = 
                            "tool1 <- function(input.table = rbci.env$selected_data, ...) {

  ## EDIT HERE

}

## EXECUTE FUNCTION ON DATA
tool1()
",
                        container = tool_edit_frame,
                        height = 550, width = 550,
                        font.attr = c(family="monospace"))


## script directory selector
tool_dir_button <- gfilebrowse(text = "Script Directory",
                               type = "selectdir",
                               container = tool_var_frame,
                               quote = FALSE)
## set initial directory to pwd
svalue(tool_dir_button) <- getwd()
## function to update script list
### TODO move to separate file
## Buttons that add new things should refresh the dataset selector

addHandlerChanged(tool_dir_button,
                  handler = function(h,...) {
                      new.scripts <-
                          dir(svalue(tool_dir_button),
                              pattern = "*.R")
                      tool_var_scriptsel[] <- new.scripts
                  })

## initialize script list for placement
script_list_frame <- gframe(text = "Scripts",
                            expand = TRUE,
                            horizontal = FALSE,
                            container = tool_var_frame)
tool_var_scriptsel <- gradio(dir(svalue(tool_dir_button),
                                 pattern = "*.R"),
                             container = script_list_frame)


tool_loadsave_frame <- gframe(text = "Load/Save",
                              container = tool_var_frame)
tool_load_button <-
    gbutton(text = "Edit Selected Script",
            container = tool_loadsave_frame,
            handler = function (h,...) {
### TODO add file directory
                ## load script file
                load.name <- svalue(tool_var_scriptsel)
                load.dir <- svalue(tool_dir_button)
                ## get text
                load.text <- 
                    readChar(paste(load.dir, load.name, sep="/"),
                             file.info(load.name)$size)
                ## make available to GUI
                svalue(tool_edit_text) <- load.text
            })

tool_save_button <-
    gbutton(text = "Save Script",
            type = "save",
            container = tool_loadsave_frame,
            handler = function (h,...) {
                file.text <-
                    svalue(tool_edit_text)

                save(file.text,
                     file = gfile(
                         filter =
                             list("R scripts"= list(patterns = ("*.R"))),
                         type = "save"))                
            })
addHandlerClicked(tool_save_button,
                  handler = function(h,...){
                      new.scripts <-
                          dir(svalue(tool_dir_button),
                              pattern = "*.R")
                      tool_var_scriptsel[] <- new.scripts
                  })

addSpring(tool_edit_frame)
tool_edit_runframe <- gframe(text = "Run/Output",
                             horizontal = TRUE,
                             container = tool_edit_frame)
tool_run_button <-
    gbutton(text = "Run Loaded Script",
            container = tool_edit_runframe,
            anchor = c(1,1),
            handler = function (h,...) {                            
                ## get data
                rbci.env$selected_data <-
                    rbci.env$importlist[svalue(tool_input_name)]
                
                ## do the call, add to dataset list
                ## save output var to env if successful
                rbci.env$importlist[svalue(tool_output_name)] <-
                    parse(text = svalue(tool_edit_text))

                ## add string manually to reporter
### TODO refactor this to match other steps
                new.step <-
                    list(summary = paste("custom function of",
                             svalue(tool_input_name)),
                         enabled = FALSE,
                         code = svalue(tool_edit_text))
                rbci.env$steplist <- append(rbci.env$steplist,
                                            list(new.step))
                
                ## print error in console if not (automatic?)
### TODO notify w/ alert

                ## update available data
                tool_input_name[] <- names(rbci.env$importlist)
            })
tool_input_name <- gdroplist(names(rbci.env$importlist),
                             container = tool_edit_runframe)
tool_output_name <- gedit(text = "Output.Variable",
                          container = tool_edit_runframe,
                          width = 25)

# set some widths (doesn't work if earlier)
svalue(tool_pane) <- 0.39

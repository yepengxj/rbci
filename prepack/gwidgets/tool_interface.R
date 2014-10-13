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
                          "tool1 <- function(rbci.env$selected_data, rbci.env$output_data, ...) {

  ## EDIT HERE

}",
                        container = tool_edit_frame,
                        height = 550, width = 550,
                        font.attr = c(family="monospace"))


# script directory selector
tool_dir_button <- gfilebrowse(text = "Script Directory",
                               type = "selectdir",
                               container = tool_var_frame,
                               quote = FALSE)
# set initial directory to pwd
svalue(tool_dir_button) <- getwd()

# initialize script list for placement
script_list_frame <- gframe(text = "Scripts",
                            expand = TRUE,
                            horizontal = FALSE,
                            container = tool_var_frame)
tool_var_filesel <- gradio(dir(svalue(tool_dir_button),
                               pattern = "*.R"),
                           container = script_list_frame)
# function to update script list
tool_update_scripts <- function(h,...) {
  # populate tool script selector
  # TODO add some kind of handler to refresh subitems in tables
  
  tool_var_filesel <- gradio(dir(svalue(tool_dir_button),
                                 pattern = "*.R"),
                             container = script_list_frame)
}
addHandlerChanged(tool_dir_button,
                  handler = tool_update_scripts())

tool_loadsave_frame <- gframe(text = "Load/Save",
                              container = tool_var_frame)
tool_load_button <- gbutton(text = "Load Selected",
                            container = tool_loadsave_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # load script file
                              
                              
                            })
tool_save_button <- gfilebrowse(text = "Save Script",
                                type = "save",
                            container = tool_loadsave_frame,
                            handler = function (h,...) {
                              
                              ## below to backend
                              # save file
                              
                              # update list to include
                              tool_update_scripts()
                            })

addSpring(tool_edit_frame)
tool_edit_runframe <- gframe(text = "Run/Output",
                             horizontal = TRUE,
                             container = tool_edit_frame)
tool_run_button <- gbutton(text = "Run Script",
                           container = tool_edit_runframe,
                           anchor = c(1,1),
                           handler = function (h,...) {
                             
                             ## the below belongs in backend
                             # get selected data file
                             
                             
                             # save output var to env if successful
                             
                             # print error in console if not (automatic?)
                             # notify w/ alert
                           })
tool_input_name <- gdroplist(names(rbci.env$importlist),
                             container = tool_edit_runframe)
tool_output_name <- gedit(text = "Output.Variable",
                          container = tool_edit_runframe,
                          width = 25)

# set some widths (doesn't work if earlier)
svalue(tool_pane) <- 0.39
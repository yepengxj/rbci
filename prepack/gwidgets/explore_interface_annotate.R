## only changes variable types for now (remember to document)

annotate_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = annotate_tab)


annotate_varlist_frame <- gframe(text = "Data Columns",
                                horizontal = FALSE,
                                container = annotate_pane,
                                expand = TRUE,
                                width = 300)
# populate varlist
annotate_varlist <- gradio(
  names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]),
  container = annotate_varlist_frame,
 # use.table = TRUE,
  expand = FALSE)

addSpring(annotate_varlist_frame)

annotate_apply_btn <- 
  gbutton(text = "Apply",
          container = annotate_varlist_frame,
          handler = function(h,...) {
            # apply changes, issue alert on success or or throw error on fail
                        # svalue(annotate_varlist)
            # TODO error handling
            
            
          })

## TODO second widget group for additional columns
# annotate_newcol_frame <- gtext(text = "annotate output",
#                               font.attr=c(family="monospace"),
#                               width = window.width*0.4,
#                               container = annotate_pane)

svalue(annotate_pane) <- 0.25
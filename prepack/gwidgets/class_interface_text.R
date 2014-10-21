text_pane <- gpanedgroup(horizontal = TRUE,
                         expand = TRUE,
                         fill = TRUE,
                         container = text_tab)


text_varlist_frame <- gframe(text = "Data Columns",
                             horizontal = FALSE,
                             container = text_pane,
                             expand = TRUE,
                             width = 300)
# populate varlist
text_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(class_var_filesel, index=TRUE)]]),
  container = text_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

text_summarize_btn <- 
  gbutton(text = "Summarize",
          container = text_varlist_frame,
          handler = function(h,...) {
            svalue(text_output_frame) <- 
              capture.output(summary(rbci.env$importlist[[
                svalue(explore_var_filesel,
                       index=TRUE)]][,svalue(summary_varlist),with=FALSE]))
          })

text_output_frame <- gtext(text = "text output",
                           font.attr=c(family="monospace"),
                           width = window.width*0.4,
                           container = text_pane)

svalue(text_pane) <- 0.25
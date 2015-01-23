summary_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = summary_tab)


summary_varlist_frame <- gframe(text = "Data Columns",
                                horizontal = FALSE,
                                container = summary_pane,
                                expand = TRUE,
                                width = 300)
# populate varlist
summary_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]),
  container = summary_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

summary_summarize_btn <- 
  gbutton(text = "Summarize",
          container = summary_varlist_frame,
          handler = function(h,...) {
              this.args <-
                  list(eeg.table =  bquote(rbci.env$importlist[[.(svalue(explore_var_filesel,
                           index=TRUE))]]), # partially dereference call
                       selected.columns = svalue(summary_varlist))
              
              svalue(summary_output_frame) <- # do the job
                  do.call(summarize, this.args)
              
            ## update the reporter module with a record of this op
            add.step(func.name = "summarize",
                     step.args = this.args)
          })

summary_output_frame <- gtext(text = "Summary output",
                              font.attr=c(family="monospace"),
                              width = window.width*0.4,
                              container = summary_pane)

svalue(summary_pane) <- 0.25

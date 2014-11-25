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
            svalue(summary_output_frame) <- 
              summarize(rbci.env$importlist[[svalue(explore_var_filesel,
                                                    index=TRUE)]],
                        svalue(summary_varlist))
          })

summary_output_frame <- gtext(text = "Summary output",
                              font.attr=c(family="monospace"),
                              width = window.width*0.4,
                              container = summary_pane)

svalue(summary_pane) <- 0.25
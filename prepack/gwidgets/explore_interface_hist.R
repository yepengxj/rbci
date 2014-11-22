hist_pane <- gpanedgroup(horizontal = TRUE,
                            expand = TRUE,
                            fill = TRUE,
                            container = hist_tab)


hist_varlist_frame <- gframe(text = "Data Columns",
                                horizontal = FALSE,
                                container = hist_pane,
                                expand = TRUE,
                                width = 300)
# populate varlist
hist_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]),
  container = hist_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

hist_summarize_btn <- 
    gbutton(text = "Plot Histogram",
            container = hist_varlist_frame,
            handler = function(h,...) {
              ## svalue(hist_output_frame) <- 
              data.melt <- melt(rbci.env$importlist[[svalue(explore_var_filesel,
                                 index=TRUE)]][,svalue(hist_varlist),
                                               with=FALSE]
                                )
              ## str(data.melt)
              visible(hist_output_frame) <- TRUE
              data.plot <-
                ggplot(data.melt,aes(x = value, color = variable)) + 
                  facet_wrap(~variable,scales = "free") +
                    geom_density()
              print(data.plot)
            })

hist_output_frame <- ggraphics(container = hist_pane)

svalue(hist_pane) <- 0.25

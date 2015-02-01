### Initialize data annotation tags for backend processing
## TODO change this from bulk init to on-demand by-file init
# rbci.env$tags[names(rbci.env$importlist)] <- list(rbci.env$taglist)

summarize <- function(eeg.table,
                      selected.columns) {
  return(capture.output(
      ## summary(rbci.env$importlist[[1]][,c(2,3),with=FALSE])
      summary(eeg.table[,selected.columns,with=FALSE])
  ))
}

### plotting function for multivariate grand means
# first arg is time column
# second arg is channel column
# third arg is class column
# http://stackoverflow.com/a/10659563/2023432
grand.means.plot <- function(eeg.table, 
                             val.name = "Voltage",
                             time.name = "Sample",
                             chan.name = "Channel",
                             targ.name = "Class",
                             plot.title = NULL) {
    title.caption <- "Averaged ERP by Class"
    if (!is.null(plot.title)) {
        title.caption <- paste(title.caption, ":\n", plot.title,
                               sep = "")
    }

    comb.class.avg <- eeg.table[,mean(get(val.name)), by = c(time.name,
                                                             chan.name,
                                                             targ.name)]
    comb.class.avg[, targ.name := as.factor(get(targ.name)),
                   with = FALSE]
    
    setnames(comb.class.avg, old=colnames(comb.class.avg),
             new=c(colnames(comb.class.avg)[1:length(
                 colnames(comb.class.avg))-1],
                 val.name))
    
    ## checkplot
    preview.plot <- 
        ggplot(comb.class.avg,
               aes_string(time.name, val.name,
                          label = targ.name, group = targ.name)) + 
               geom_line(aes_string(colour = targ.name )) +
               stat_smooth(aes_string(colour = targ.name),
                           method = "loess", level=0.9) +
               facet_wrap(as.formula(paste("~", chan.name)), ncol=4) +
               ggtitle(title.caption) +
               xlab(time.name) + ylab("Amplitude (uV)") +
               ## guides(col = guide_legend(nrow = 28, byrow=TRUE,
               ##                           title = "Channel")) +
               theme(plot.title = element_text(size = 18, face = "bold", 
                                               colour = "black", vjust=1))
    preview.plot
}

hist.plot <- function(data.set) {
    data.melt <- melt(data.set)
    
    data.plot <-
        ggplot(data.melt,aes(x = value, color = variable)) + 
            facet_wrap(~variable,scales = "free") +
                geom_density()

    return(data.plot)
}

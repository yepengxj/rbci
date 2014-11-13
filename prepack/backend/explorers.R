### Initialize data annotation tags for backend processing
## TODO change this from bulk init to on-demand by-file init
rbci.env$tags[names(rbci.env$importlist)] <- list(rbci.env$taglist)

summarize <- function(eeg.table,
                      selected.columns) {
  return(capture.output(
      ## summary(rbci.env$importlist[[1]][,c(2,3),with=FALSE])
      summary(eeg.table[,selected.columns,with=FALSE])
  ))
}

# first arg is time column
# second arg is channel column
# third arg is class column
# http://stackoverflow.com/a/10659563/2023432
grand.means.plot <- function(eeg.table, 
                     val.name = "Voltage",
                     col.groups = c("Sample","Channel","Class")){
  eval(substitute(
    expr = {
      # first arg is time column
      # second arg is channel column
      # third arg is class column
      comb.class.avg <- eeg.table[,mean(get(val.name)), by = col.groups]
      comb.class.avg[, col.groups[3] := as.factor(Class)]
      
      setnames(comb.class.avg, old=colnames(comb.class.avg),
               new=c(colnames(comb.class.avg)[1:length(
                 colnames(comb.class.avg))-1],
                 val.name))
      
      # checkplot
      # preview.plot <- 
        ggplot(comb.class.avg,
               aes_string(col.groups[1], val.name,
                          label = col.groups[3], group = col.groups[3])) + 
        geom_line(aes_string(colour = col.groups[3] )) +
        stat_smooth(aes(colour = get(col.groups[3])),
                    method = "loess", level=0.9) +
        facet_wrap(as.formula(paste("~",col.groups[2])), ncol=4) +
        ggtitle(bquote("Averaged ERP by Class")) +
        xlab(col.groups[1]) + ylab("Amplitude (uV)") +
        ## guides(col = guide_legend(nrow = 28, byrow=TRUE, title = "Channel")) +
        theme(plot.title = element_text(size = 18, face = "bold", 
                                        colour = "black", vjust=1))
    }, 
    env = list(val.name = val.name,
               col.groups = col.groups)))
}

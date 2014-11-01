#' Import functions for external data files.
#' 
#' Each of these functions imports data into a specified enivronment.
#' 
#' @param filename A string pointing to the data file.
#' @param environment The desired enviroment to receive the data.
#' @param options A list of named options
#' @return If import OK, outputs a preview of the imported data 
#' @name Import backends
NULL

#' @rdname matlab.type2.import
matlab_type2_import <- function(init.struct,eeg.ind,tgt.ind,preview = FALSE) {
  
  # TODO remove structural hardcoding to frontend
  init.eeg <- init.struct$eeg[[eeg.ind]]
  init.tgt <- init.struct$eeg[[tgt.ind]]
  
  eeg.table <- melt(init.eeg,
                    varnames = c("Trial","Sample","Channel"),
                    value.name = "Voltage")
  eeg.table <- as.data.table(eeg.table)
  
  
  eeg.table[,Class:=init.tgt]
  
  if (preview == TRUE) {
    comb.class.avg <- eeg.table[,mean(Voltage),by=c("Sample","Channel","Class")]
    comb.class.avg[,Class:= as.factor(Class)]
    
    setnames(comb.class.avg,old=colnames(comb.class.avg),
             new=c(colnames(comb.class.avg)[1:length(
               colnames(comb.class.avg))-1],
               "Voltage"))
    
    # checkplot
    preview.plot <- 
      ggplot(comb.class.avg,
             aes(Sample,Voltage, label=Target, group=Target)) + 
      geom_line(aes(colour= Target )) +
      stat_smooth(aes(colour= Target), method = "loess", level=0.9) +
      facet_wrap(~ Channel, ncol=4) +
      ggtitle(bquote("Averaged ERP by Class")) +
      xlab("Sample") + ylab("Amplitude (uV)") +
      # guides(col = guide_legend(nrow = 28, byrow=TRUE, title = "Channel")) +
      theme(plot.title = element_text(size = 18, face = "bold", 
                                      colour = "black", vjust=1))
    
    return(list(eeg.table = eeg.table, preview.plot = preview.plot))
  }
  
  return(list(eeg.table = eeg.table))
}
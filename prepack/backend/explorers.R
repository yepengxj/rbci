comb.class.avg <- erp[,mean(Voltage),by=c("Time","Channel","Class")]
comb.class.avg[,Class:= as.factor(Class)]

setnames(comb.class.avg,old=colnames(comb.class.avg),
         new=c(colnames(comb.class.avg)[1:length(
           colnames(comb.class.avg))-1],
           "Voltage"))

# checkplot
ggplot(comb.class.avg,
       aes(Time,Voltage, label=Class, group=Class)) + 
  geom_line(aes(colour= Class )) +
  stat_smooth(aes(colour= Class), method = "loess", level=0.9) +
  facet_wrap(~ Channel, ncol=4) +
  ggtitle(bquote("Averaged ERP by Class")) +
  xlab("Sample") + ylab("Amplitude (uV)") +
  # guides(col = guide_legend(nrow = 28, byrow=TRUE, title = "Channel")) +
  theme(plot.title = element_text(size = 18, face = "bold", colour = "black", 
                                  vjust=1))
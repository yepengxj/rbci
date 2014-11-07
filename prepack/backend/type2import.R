library(R.matlab)
library(data.table)
library(ggplot2)
library(reshape2)

init.struct <- readMat("./s1_AU_1_epoched.mat")

init.eeg <- init.struct$eeg[[1]]
init.tgt <- init.struct$eeg[[3]]

eeg.table <- melt(init.eeg,
                  varnames = c("Trial","Sample","Channel"),
                  value.name = "Voltage")
eeg.table <- as.data.table(eeg.table)

eeg.table[,Target:=init.tgt]


# qplot(eeg.table[,Trial],eeg.table[,Target])

comb.class.avg <- erp[,mean(Voltage),by=c("Sample","Channel","Class")]
comb.class.avg[,Class:= as.factor(Class)]
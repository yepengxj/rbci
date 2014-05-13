library(RGtk2)
library(cairoDevice)

# Loads initial interface window, which is mainly for choosing tasks.
init.win <- gtkWindow()
init.win["title"] <- "RBCI Main Window"
##### Task choices #####
# set up layout
task.frame = gtkFrameNew("Task Chooser")
task.frame["label-xalign"] <- 1
init.win$add(task.frame)

## box for widgets
# Create vertical container
task.vbox = gtkVBoxNew(FALSE, 8)
task.vbox$setBorderWidth(24)
task.frame$add(task.vbox)

# create buttons

task.buttonbox = gtkVButtonBoxNew()
task.buttonbox$setBorderWidth(5)
task.vbox$add(task.buttonbox)
task.buttonbox$setLayout("start")
task.buttonbox$setSpacing(10)

# buttonOK = gtkButtonNewFromStock("gtk-ok")
# gSignalConnect(buttonOK, "clicked", performStatistics)
# buttonCancel = gtkButtonNewFromStock("gtk-close")

## Add button: data import assistant
dataimport.button <- gtkButtonNewWithMnemonic("_Import/Load Data")
task.buttonbox$packStart(dataimport.button,fill=F)

## Add button: data exploration tool
explore.button <- gtkButtonNewWithMnemonic("_Explore/Annotate Data")
task.buttonbox$packStart(explore.button,fill=F)

## Add button: data stream tool
stream.button <- gtkButtonNewWithMnemonic("Create/Load Online _Stream")
task.buttonbox$packStart(stream.button,fill=F)

## Add button: tool builder
tool.button <- gtkButtonNewWithMnemonic("Create/Load Custom _Tool")
task.buttonbox$packStart(tool.button,fill=F)

## Add button: transforms
trans.button <- gtkButtonNewWithMnemonic("Transforms/_Unsupervised Learning")
task.buttonbox$packStart(trans.button,fill=F)

## Add button: classification/supervised
class.button <- gtkButtonNewWithMnemonic("Classification/_Supervised Learning")
task.buttonbox$packStart(class.button,fill=F)

## Add button: classification/supervised
report.button <- gtkButtonNewWithMnemonic("Review/Generate _Reports")
task.buttonbox$packStart(report.button,fill=F)

## quit button
quit.button <- gtkButtonNewFromStock("gtk-quit")
task.buttonbox$packStart(quit.button,fill=F)
gSignalConnect(quit.button, "clicked", init.win$destroy)
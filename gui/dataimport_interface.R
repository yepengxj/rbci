library(RGtk2)
library(cairoDevice)

# data import script
import.win <- gtkWindow()
import.win["title"] <- "Data Import"
##### data type choices #####
# set up layout
import.frame = gtkFrameNew()
# import.frame["label-xalign"] <- 1
import.win$add(import.frame)

## box for widgets
# Create vertical container
import.vbox = gtkVBoxNew(FALSE, 8)
import.vbox$setBorderWidth(24)
import.frame$add(import.vbox)

# create buttons
import.buttonbox = gtkVButtonBoxNew()
import.buttonbox$setBorderWidth(5)
import.vbox$add(import.buttonbox)
import.buttonbox$setLayout("start")
import.buttonbox$setSpacing(10)

## Add button: MATLAB data
matlab.button <- gtkExpanderNewWithMnemonic ("_MATLAB Data") #gtkButtonNewWithMnemonic("MATLAB Data")
import.buttonbox$packStart(matlab.button,fill=F)

## Add button: BCI2000 data
bci2k.button <- gtkButtonNewWithMnemonic("bci2000 Data")
import.buttonbox$packStart(bci2k.button,fill=F)

## Add button: Text formats
text.button <- gtkButtonNewWithMnemonic("Text Data")
import.buttonbox$packStart(text.button,fill=F)


##### MATLAB data importer activity #####
gSignalConnect(matlab.button, "notify::expanded", matlab.expander.callback)

matlab.expander.callback <- (matlab.button, param.spec, user.data) {
  if(matlab.button$getExpanded()) {
    matlab.frame = gtkFrameNew("MATLAB Data")
    # import.frame["label-xalign"] <- 1
    import.win$add(matlab.frame)
    # ["title"] <- "MATLAB Data Import"
    # import.win$destroy
  }
  else {
  }
}
library(RGtk2)
library(cairoDevice)

##### main window button actions #####
on_quitbutton_clicked <- function(action) {
  builder$getObject("initwindow")$destroy()
}

on_importbutton_clicked <- function(action) {
  importwindow <- builder$getObject("importwindow")
  importwindow$showAll()
}

on_explorebutton_clicked <- function(action) {
  explorewindow <- builder$getObject("explorewindow")
  explorewindow$showAll()
}

# bring up GTKBuilder GUI
builder <- gtkBuilder()
filename <- "./gui/glade/gladeinterface.glade"
res <- builder$addFromFile(filename)
if (!is.null(res$error))
  stop("ERROR: ", res$error$message)
builder$connectSignals(NULL)
window <- builder$getObject("initwindow")

window$showAll()
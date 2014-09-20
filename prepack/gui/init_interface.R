##### TODO breakout these dependencies to correct spot in package
library(RGtk2)
library(cairoDevice)
library(R.matlab)

##### main window button actions #####
on_quitbutton_clicked <- function(action) {
  objlist <- builder$getObjects()
  for (obj in objlist) {
    if (class(obj)[1] == "GtkWindow") {
      # destroy all GtkWindows on quit
      obj$destroy()
    }
  }
}

on_importbutton_clicked <- function(action) {
  importwindow <- builder$getObject("importwindow")
  importwindow$showAll()
}

on_explorebutton_clicked <- function(action) {
  explorewindow <- builder$getObject("explorewindow")
  explorewindow$showAll()
}

# Initialize import frontend code
source("./gui/import_interface.R")
# Initialize backend processing
source("./backend/init_backend.R")

# bring up GTKBuilder GUI
builder <- gtkBuilder()
guilayout <- "./gui/glade/gladeinterface.glade"
res <- builder$addFromFile(guilayout)
if (!is.null(res$error))
  stop("ERROR: ", res$error$message)
builder$connectSignals(NULL)
window <- builder$getObject("initwindow")

window$showAll()
##### import window button actions #####

on_importmatfilechoosebutton_file_set <- function(action) {
  message("filebuttonactivated")
  previewselector <- builder$getObject("importmatfilechoosebutton")
  
  rbci.env$previewfile <- previewselector$GetFilename()
  # get some options also
  
  # here we need to go to the backend to process the MAT
  rbci.env$previewtext <- rbci.preview.mat(rbci.env$previewfile)
}

on_importmatpreviewbutton_clicked <- function(action) {
  message("previewclicked")
  # set text if preview load succeeded
  previewbuf <- builder$getObject("datapreviewtext")
  previewbuf$text <- paste(rbci.env$previewtext,collapse="\n")
  
  # update options based on data characteristics (available cols, etc.)
  
  # add cols to listview
  collist <- builder$getObject("importoptslist")
  coliter <- gtkListStoreAppend(collist)
  # gtkListStoreSet(collist,coliter$iter, 0, "thing", -1)
  
  gtkListStoreSetValue(collist,coliter$iter, 0, "thing")
  
#   sapply("thing",
#          function(string) {
#            ## Add a new row to the model
#            iter <- collist$append(coliter)$iter
#            collist$set(iter, 0, string, 1, i, 2,  FALSE)
#          })
}
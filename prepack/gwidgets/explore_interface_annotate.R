## only changes variable types for now (remember to document)

annotate_mainframe <- gpanedgroup(horizontal = TRUE,
                                  expand = TRUE,
                                  fill = TRUE,
                                  container = annotate_tab)


annotate_varlist_frame <- gframe(text = "Data Columns",
                                 horizontal = FALSE,
                                 container = annotate_mainframe,
                                 expand = TRUE,
                                 width = 300)
### populate varlist
annotate_varlist <- gradio(
  names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]),
  container = annotate_varlist_frame,
  ## use.table = TRUE,
  expand = FALSE,
  handler = function(h, ...) {
    
    ## update current datatype
    svalue(annotate_curvartype) <-
      paste("Current Data Type:", 
            sapply(rbci.env$importlist[[svalue(explore_var_filesel)]],
                   class)[svalue(annotate_varlist)])

    ## TODO: are these updates needed? (probably not)
    ## update current tag
    svalue(annotate_curtarget) <- 
      paste("Current Target Column:",
            rbci.env$tags[[svalue(explore_var_filesel)]]$targetcol)
    
    ## update current tag
    svalue(annotate_curvalue) <- 
      paste("Current Value Column:",
            rbci.env$tags[[svalue(explore_var_filesel)]]$valuecol)

    svalue(annotate_curepoch) <- 
      paste("Current Epoch Column:",
            rbci.env$tags[[svalue(explore_var_filesel)]]$epochcol)
  })

addSpring(annotate_varlist_frame)


### TODO second widget group for creating additional columns
annotate_optframe <- gframe(text = "Annotation Options",
                            container = annotate_mainframe,
                            horizontal = FALSE)

## variable type
glabel("Data Type",
       container = annotate_optframe,
       anchor = c(-1,1))

annotate_curvartype <- glabel("Current Data Type: ",
                              container = annotate_optframe,
                              anchor = c(-1,1))

glabel("New Data Type",
       container = annotate_optframe,
       anchor = c(-1,1))

annotate_datatype_chooser <- 
  gdroplist(c("Numeric","Integer","Complex","Logical","Character"),
            container = annotate_optframe,
            anchor = c(-1,1))

annotate_datatype_apply <-
  gbutton("Apply",
          container = annotate_optframe,
          handler = function(h, ...) {
            switch(svalue(annotate_datatype_chooser),
                   Numeric = {
                     rbci.env$importlist[[svalue(explore_var_filesel)]][, svalue(annotate_varlist) :=
                                                                          as.numeric(get(svalue(annotate_varlist)))]
                   },
                   Integer = {
                     rbci.env$importlist[[svalue(explore_var_filesel)]][, svalue(annotate_varlist) :=
                                                                          as.integer(get(svalue(annotate_varlist)))]
                   },
                   Complex = {
                     rbci.env$importlist[[svalue(explore_var_filesel)]][, svalue(annotate_varlist) :=
                                                                          as.complex(get(svalue(annotate_varlist)))]
                   },
                   Logical = {
                     rbci.env$importlist[[svalue(explore_var_filesel)]][, svalue(annotate_varlist) :=
                                                                          as.logical(get(svalue(annotate_varlist)))]},
                   Character = {
                     rbci.env$importlist[[svalue(explore_var_filesel)]][, svalue(annotate_varlist) :=
                                                                          as.character(get(svalue(annotate_varlist)))]
                   })
            
            svalue(annotate_curvartype) <-
              paste("Current Data Type:", 
                    sapply(rbci.env$importlist[[svalue(explore_var_filesel)]],
                           class)[svalue(annotate_varlist)])
          })


### interest tag: target, value
glabel("Column Tag",
       container = annotate_optframe,
       anchor = c(-1,1))

annotate_datatype_chooser <- 
  gdroplist(c("No Tag","Target Column", "Value Column", "Epoch Column"),
            container = annotate_optframe,
            anchor = c(-1,1),
            handler = function(h, ...) {

              if ( svalue(h$obj) == "Target Column") {
                ## set target tag
                rbci.env$tags[[svalue(explore_var_filesel)]]$targetcol <-
                  svalue(annotate_varlist)
                ## update display
                svalue(annotate_curtarget) <-
                  paste("Current Target Column:", svalue(annotate_varlist))
              }
              else if ( svalue(h$obj) == "Value Column") {
                ## set value tag
                rbci.env$tags[[svalue(explore_var_filesel)]]$valuecol <-
                  svalue(annotate_varlist)
                ## update display
                svalue(annotate_curvalue) <-
                  paste("Current Value Column:", svalue(annotate_varlist))
              }
              else if ( svalue(h$obj) == "Epoch Column") {
                ## set value tag
                rbci.env$tags[[svalue(explore_var_filesel)]]$epochcol <-
                  svalue(annotate_varlist)
                ## update display
                svalue(annotate_curepoch) <-
                  paste("Current Epoch Column:", svalue(annotate_varlist))
              }
              else if ( svalue(h$obj) == "No Tag") {
                ## match tags, then delete if needed
                if (svalue(annotate_curtarget) ==
                    paste("Current Target Column:",
                          svalue(annotate_varlist))) {
                  rbci.env$tags[[svalue(explore_var_filesel)]]$targetcol <-
                    NULL

                  svalue(annotate_curtarget) <-
                    paste("Current Target Column: None")
                }
                if (svalue(annotate_curvalue) <-
                  paste("Current Value Column:",
                        svalue(annotate_varlist))) {

                  rbci.env$tags[[svalue(explore_var_filesel)]]$valuecol <-
                    NULL

                  svalue(annotate_curvalue) <-
                    paste("Current Value Column: None")
                }
                if (svalue(annotate_curepoch) <-
                  paste("Current Epoch Column:",
                        svalue(annotate_varlist))) {

                  rbci.env$tags[[svalue(explore_var_filesel)]]$epochcol <-
                    NULL

                  svalue(annotate_curepoch) <-
                    paste("Current Epoch Column: None")
                }
              }
            })
annotate_curtarget <-
  glabel("Current Target Column:",
         container = annotate_optframe,
         anchor = c(-1,1))

annotate_curvalue <-
  glabel("Current Value Column:",
         container = annotate_optframe,
         anchor = c(-1,1))

annotate_curepoch <-
  glabel("Current Epoch Column:",
         container = annotate_optframe,
         anchor = c(-1,1))

## annotate_apply_btn <- 
##   gbutton(text = "Apply",
##           container = annotate_optframe,
##           handler = function(h,...) {
##             # apply changes, issue alert on success or or throw error on fail
##             # svalue(annotate_varlist)
##             # TODO error handling
##             
##               
##               
## 
##           })

svalue(annotate_mainframe) <- 0.25

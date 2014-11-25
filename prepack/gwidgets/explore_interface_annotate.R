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
              curfile <- svalue(explore_var_filesel)
              curcol <- svalue(annotate_varlist)
            switch(svalue(annotate_datatype_chooser),
             Numeric = {
                 rbci.env$importlist[[curfile]][, curcol :=
                                                    as.numeric(get(curcol))]
             },
             Integer = {
                 rbci.env$importlist[[curfile]][, curcol :=
                                                    as.integer(get(curcol))]
             },
             Complex = {
                 rbci.env$importlist[[curfile]][, curcol :=
                                                    as.complex(get(curcol))]
             },
             Logical = {
                 rbci.env$importlist[[curfile]][, curcol :=
                                                    as.logical(get(curcol))]},
             Character = {
                 rbci.env$importlist[[curfile]][, curcol :=
                                                    as.character(get(curcol))]
             })
 
            svalue(annotate_curvartype) <-
              paste("Current Data Type:", 
                    sapply(rbci.env$importlist[[curfile]],
                           class)[curcol])
          })


### interest tag: target, value
glabel("Column Tag",
       container = annotate_optframe,
       anchor = c(-1,1))

annotate_datatype_chooser <- 
  gdroplist(c("No Tag","Target Column", "Value Column", "Epoch Column",
              "Time Column","Channel Column"),
            container = annotate_optframe,
            anchor = c(-1,1),
            handler = function(h, ...) {
                curfile <- svalue(explore_var_filesel)
                curcol <- svalue(annotate_varlist)

                ## TODO clean up this vile switch statement
              if ( svalue(h$obj) == "Target Column") {
                ## set target tag
                rbci.env$tags[[curfile]]$targetcol <- curcol
                ## update display
                svalue(annotate_curtarget) <-
                  paste("Current Target Column:", curcol)
              }
              else if ( svalue(h$obj) == "Value Column") {
                ## set value tag
                rbci.env$tags[[curfile]]$valuecol <- curcol
                ## update display
                svalue(annotate_curvalue) <-
                  paste("Current Value Column:", curcol)
              }
              else if ( svalue(h$obj) == "Epoch Column") {
                ## set value tag
                rbci.env$tags[[curfile]]$epochcol <- curcol
                ## update display
                svalue(annotate_curepoch) <-
                  paste("Current Epoch Column:", curcol)
              }
              else if ( svalue(h$obj) == "Time Column") {
                ## set value tag
                rbci.env$tags[[curfile]]$timecol <- curcol
                ## update display
                svalue(annotate_curtime) <-
                  paste("Current Time Column:", curcol)
              }
              else if ( svalue(h$obj) == "Channel Column") {
                ## set value tag
                rbci.env$tags[[curfile]]$chancol <- curcol
                ## update display
                svalue(annotate_curchan) <-
                  paste("Current Channel Column:", curcol)
              }
              else if ( svalue(h$obj) == "No Tag") {
                ## match tags, then delete if needed
                if (svalue(annotate_curtarget) ==
                    paste("Current Target Column:", curcol)) {
                  rbci.env$tags[[curfile]]$targetcol <- NULL

                  svalue(annotate_curtarget) <-
                    paste("Current Target Column: None")
                }
                if (svalue(annotate_curvalue) <-
                  paste("Current Value Column:", curcol)) {

                  rbci.env$tags[[curfile]]$valuecol <- NULL

                  svalue(annotate_curvalue) <-
                    paste("Current Value Column: None")
                }
                if (svalue(annotate_curepoch) <-
                  paste("Current Epoch Column:", curcol)) {

                  rbci.env$tags[[curfile]]$epochcol <- NULL

                  svalue(annotate_curepoch) <-
                    paste("Current Epoch Column: None")
                }
                if (svalue(annotate_curtime) <-
                  paste("Current Time Column:", curcol)) {

                  rbci.env$tags[[curfile]]$timecol <- NULL

                  svalue(annotate_curtime) <-
                    paste("Current Time Column: None")
                }
                if (svalue(annotate_curchan) <-
                  paste("Current Channel Column:", curcol)) {

                  rbci.env$tags[[curfile]]$chancol <- NULL

                  svalue(annotate_curchan) <-
                    paste("Current Channel Column: None")
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

annotate_curtime <-
  glabel("Current Time Column:",
         container = annotate_optframe,
         anchor = c(-1,1))

annotate_curchan <-
  glabel("Current Channel Column:",
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

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
# populate varlist
annotate_varlist <- gradio(
  names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]),
  container = annotate_varlist_frame,
 # use.table = TRUE,
  expand = FALSE)

addSpring(annotate_varlist_frame)

annotate_apply_btn <- 
  gbutton(text = "Apply",
          container = annotate_varlist_frame,
          handler = function(h,...) {
            # apply changes, issue alert on success or or throw error on fail
                        # svalue(annotate_varlist)
            # TODO error handling
            
            
          })

## TODO second widget group for creating additional columns
annotate_optframe <- gframe(text = "Annotation Options",
                            container = annotate_mainframe,
                            horizontal = FALSE)

# variable type
glabel("Data Type",
       container = annotate_optframe)
glabel("Current Data Type",
       container = annotate_optframe)
annotate_curvartype <- glabel("Current Data Type: ",
                              container = annotate_optframe)

glabel("New Data Type",
       container = annotate_optframe)
annotate_datatype_chooser <- 
  gdroplist(c("Numeric","Integer","Complex","Logical","Character"),
            container = annotate_optframe)


# interest tag: target, value
glabel("Column Tag",
       container = annotate_optframe)

annotate_datatype_chooser <- 
  gdroplist(c("Target Column", "Value Column"),
            container = annotate_optframe)
annotate_curtarget <- glabel("Current Target Column:",
                             container = annotate_optframe)
annotate_curvalue <- glabel("Current Value Column:",
                            container = annotate_optframe)

svalue(annotate_mainframe) <- 0.25
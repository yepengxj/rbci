## partition params
partition_param_frame <- gframe(text = "Partition Parameters",
                             horizontal = FALSE,
                             container = partition_tab,
                             expand = TRUE)

### type
partition_type_list <- c("Random","Sequential")
partition_type_label <- glabel(text = "Partition Type",
                           container = partition_param_frame)
partition_type_menu <- 
    gdroplist(partition_type_list,
              text = "Partition Type",
              container = partition_param_frame)

### numerical entry (spinboxes)
partition_band_label <- glabel(text = "Numerical Parameters",
                            container = partition_param_frame)
partition_band_layout <- glayout(container = partition_param_frame)

## sampling factor
partition_band_layout[1,1] <- "Number of Sets"
partition_band_layout[2,1] <-
    gspinbutton(from = 2, to = 4, by = 1,
                value = 2,
                handler = function(h,...){
                    switch(as.character(svalue(h$obj)),
                           "2"={
                               enabled(partition_band_layout[1,2]) <- TRUE
                               enabled(partition_band_layout[2,2]) <- TRUE
                               enabled(partition_band_layout[3,1]) <- FALSE
                               enabled(partition_band_layout[4,1]) <- FALSE
                               enabled(partition_band_layout[3,2]) <- FALSE
                               enabled(partition_band_layout[4,2]) <- FALSE
                           },
                           "3"={
                               enabled(partition_band_layout[1,2]) <- TRUE
                               enabled(partition_band_layout[2,2]) <- TRUE
                               enabled(partition_band_layout[3,1]) <- TRUE
                               enabled(partition_band_layout[4,1]) <- TRUE
                               enabled(partition_band_layout[3,2]) <- FALSE
                               enabled(partition_band_layout[4,2]) <- FALSE
                           },
                           "4"={
                               enabled(partition_band_layout[1,2]) <- TRUE
                               enabled(partition_band_layout[2,2]) <- TRUE
                               enabled(partition_band_layout[3,1]) <- TRUE
                               enabled(partition_band_layout[4,1]) <- TRUE
                               enabled(partition_band_layout[3,2]) <- TRUE
                               enabled(partition_band_layout[4,2]) <- TRUE
                           })
                })

partition_band_layout[1,2] <- "Set 1 Proportion"
partition_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.001,
                                          value = 0.5)

partition_band_layout[3,1] <- "Set 2 Proportion"
partition_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.001,
                                          value = 0.5)

partition_band_layout[3,2] <- "Set 3 Proportion"
partition_band_layout[4,2] <- gspinbutton(from = 0, to = 1, by = 0.001)

enabled.list(state = FALSE,
             partition_band_layout[3,1],
             partition_band_layout[3,2],
             partition_band_layout[4,1],
             partition_band_layout[4,2])
 
## application params
partition_grouping_frame <- gframe(text = "Partition Apply Rules",
                             horizontal = FALSE,
                             container = partition_param_frame,
                             expand = TRUE,
                             width = 300)
## trial/group vars
partition_grouping_label <- glabel(text = "Data Grouping",
                                   container = partition_grouping_frame)
partition_grouping_layout <- glayout(container = partition_grouping_frame)

partition_grouping_layout[1,1] <- "Partition Group (Trials)"
partition_grouping_layout[2,1] <- 
    gcombobox(
        names(rbci.env$importlist[[svalue(explore_var_filesel, index=TRUE)]]))

## output params
partition_output_frame <- gframe(text = "Output Controls",
                                  horizontal = FALSE,
                                  container = partition_param_frame,
                                  expand = FALSE,
                                  width = 320)

# apply partition button
partition_apply_btn <-
    gbutton("Apply Partition to Data",
            container = partition_output_frame,
            handler = function(h,...){
                ## proportion inputs depend on how many subsets we have
                switch(as.character(svalue(partition_band_layout[2,1])),
                       "2"={
                           part.props <-
                               c(svalue(partition_band_layout[2,2]),
                                 1-svalue(partition_band_layout[2,2]))
                       },
                       "3"={
                           prop.total <- sum(svalue(partition_band_layout[2,2]),
                                             svalue(partition_band_layout[4,1]))
                           part.props <-
                               c(svalue(partition_band_layout[2,2]),
                                 svalue(partition_band_layout[4,1]),
                                 1-prop.total)
                       },
                       "4"={
                           ## normalize
                           prop.total <- sum(svalue(partition_band_layout[2,2]),
                                             svalue(partition_band_layout[4,1]),
                                             svalue(partition_band_layout[4,2]))
                           part.props <- c(svalue(partition_band_layout[2,2]),
                                           svalue(partition_band_layout[4,1]),
                                           svalue(partition_band_layout[4,2]),
                                           1-prop.total)
                       })
                
### TODO throw error if props are malformed
                file.name <- svalue(explore_var_filesel)
                part.file <- rbci.env$importlist[[file.name]]
                part.col <- svalue(partition_grouping_layout[2,1])
                part.type <- svalue(partition_type_menu)
                
                ## apply the partition, add new data tables to list
                new.tables <- list(partition.table(part.file,
                                                   part.col,
                                                   part.props,
                                                   part.type)
                                   )
                ## naming for clarity
                names(new.tables) <- paste(file.name,
                                           "part", seq_along(new.tables),
                                           sep = ".")
                
                rbci.env$importlist <-
                    append(rbci.env$importlist,list(new.tables))
                ## ensure names are straight
                names(rbci.env$importlist) <-
                    make.unique(names(rbci.env$importlist))
            })

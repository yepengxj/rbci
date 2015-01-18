build_snowfields <- function(num.clusters, oldframe, container) {
### Builds form layout for SNOW cluster config
    snowopts_layout <<- glayout()
    
    refresh.widget(container, oldframe) # delete old layout

    sapply(seq_len(num.clusters), function(this.row) {

        snowopts_layout[this.row,1] <- paste("Machine",this.row)
        snowopts_layout[this.row,2] <- glabel("Hostname", editable = TRUE)
        snowopts_layout[this.row,3] <- glabel("RScript path", editable = TRUE)
        snowopts_layout[this.row,4] <- glabel("SNOW library path", editable = TRUE)
        
    })

}

snow_backendopts_frame <- gframe(horizontal = FALSE,
                                 text = "SNOW cluster options")
## initialize lower layout again
refresh.widget(parallel_frame, backendopts_frame, snow_backendopts_frame)
backendopts_frame <- snow_backendopts_frame # add simple name reference
snow_numclust <- gspinbutton(from = 1, to = 16, value = 1,
                                    container = backendopts_frame)
snow_cfg_btn <-
    gbutton("Configure clusters",
            container = backendopts_frame,
            handler = function(h,...) {
                build_snowfields(svalue(snow_numclust),
                                 backendopts_frame,
                                 parallel_frame)

            })

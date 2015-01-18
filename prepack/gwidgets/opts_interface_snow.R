build_snowfields <- function(num.clusters, oldframe, container) {
### Builds form layout for SNOW cluster config
    if (exists('snowopts_layout') && isExtant(snowopts_layout)) {
        delete(oldframe, snowopts_layout)
    }
    snowopts_layout <<- glayout()
    
    refresh.widget(container, oldframe) # delete old layout

    sapply(seq_len(num.clusters), function(this.row) {

        snowopts_layout[this.row,1] <- paste("Machine",this.row)
        snowopts_layout[this.row,2] <- glabel("Hostname",
                                              editable = TRUE)
        snowopts_layout[this.row,3] <- glabel("RScript path",
                                              editable = TRUE)
        snowopts_layout[this.row,4] <- glabel("SNOW library path",
                                              editable = TRUE)
        return()
    })
    add(oldframe, snowopts_layout)
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

snow_control_frame <- gframe("Cluster control",
                             container = backendopts_frame,
                             center = TRUE)
snow_start_btn <-
    gbutton("Start Cluster",
            container = snow_control_frame,
            handler = function(h,...) {
                cluster.optslist <-
                    vector("list", # hack: we know how many columns in layout
                           length(snowopts_layout[])/4)
                for (this.row in seq_along(cluster.optslist)) {
                    cluster.optslist[[this.row]] <- 
                        list(host = svalue(snowopts_layout[this.row,2]),
                             rscript = svalue(snowopts_layout[this.row,3]),
                             snowlib = svalue(snowopts_layout[this.row,4]))
                    }
### TODO error checking on opts (fails silently if malformed)
                rbci.env$cluster <-
                    makeCluster(cluster.optslist,
                                type = "SOCK")
                registerDoSNOW(rbci.env$cluster)
            })

snow_stop_btn <-
    gbutton("Stop Cluster",
            container = snow_control_frame,
            handler = function(h,...){
                stopCluster(rbci.env$cluster)
            })

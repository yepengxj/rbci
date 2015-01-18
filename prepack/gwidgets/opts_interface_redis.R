build_redisfields <- function(num.clusters, oldframe, container) {
### Builds form layout for Redis config
    if (exists('redisopts_layout') && isExtant(redisopts_layout)) {
        delete(oldframe, redisopts_layout)
    }
    redisopts_layout <<- glayout()
    
    refresh.widget(container, oldframe) # delete old layout

    sapply(seq_len(num.clusters), function(this.row) {

        redisopts_layout[this.row,1] <- paste("Queue",this.row)
        redisopts_layout[this.row,2] <- glabel("Hostname",
                                              editable = TRUE)
        redisopts_layout[this.row,3] <- glabel("Port",
                                              editable = TRUE)
        redisopts_layout[this.row,4] <- glabel("Password",
                                              editable = TRUE)
        return()
    })
    add(oldframe, redisopts_layout)
}

redis_backendopts_frame <- gframe(horizontal = FALSE,
                                 text = "Redis queue options")
## initialize lower layout again
refresh.widget(parallel_frame, backendopts_frame, redis_backendopts_frame)
backendopts_frame <- redis_backendopts_frame # add simple name reference
redis_numclust <- gspinbutton(from = 1, to = 16, value = 1,
                                    container = backendopts_frame)
redis_cfg_btn <-
    gbutton("Configure queues",
            container = backendopts_frame,
            handler = function(h,...) {
                build_redisfields(svalue(redis_numclust),
                                 backendopts_frame,
                                 parallel_frame)

            })

redis_control_frame <- gframe("Queue control",
                             container = backendopts_frame,
                             center = TRUE)
redis_start_btn <-
    gbutton("Register Queues",
            container = redis_control_frame,
            handler = function(h,...) {
                queue.optslist <-
                    vector("list", # hack: we know how many columns in layout
                           length(redisopts_layout[])/4)
                for (this.row in seq_along(queue.optslist)) {
                    queue.optslist[[this.row]] <- 
                        list(queue = svalue(redisopts_layout[this.row,1]),
                             hostname = svalue(redisopts_layout[this.row,2]),
                             port = svalue(redisopts_layout[this.row,3]),
                             password = svalue(redisopts_layout[this.row,4]))
                    }
### TODO error checking on opts (fails silently if malformed)
                rbci.env['redisqueue'] <- # return queue names for later
                                       # deregistration
                    lapply(queue.optslist, function(this.queue) {
                        registerDoRedis(unlist(this.queue))
                        return(this.queue['queue'])
                    })
            })

redis_stop_btn <-
    gbutton("Stop Queues",
            container = redis_control_frame,
            handler = function(h,...) {
                lapply(rbci.env['redisqueue'], removeQueue)
                ### TODO add error handling for queue status
            })

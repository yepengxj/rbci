window.width <- 450
window.height <- 500

opts_win <- gwindow("Parallelization Options",
                    width = window.width,
                    height = window.height)

parallel_frame <- gframe(container = opts_win,
                         horizontal = FALSE)

parallel_label <- glabel("Options",
                         container = parallel_frame)
parallelbackend_type_list <- c("multicore")

parallelbackend_type_menu <- 
  gdroplist(parallelbackend_type_list,
            text = "Backend Type",
            container = parallel_frame,
            handler = function (h,...) {
              # enable or disable param GUI opts on type change
              
              ## param names by type
              # sigma for rbf/Laplace
              # degree, scale, offset for Polynomial
              # scale, offset for tanhdot
              # sigma, order, degree, for Bessel
              # sigma, degree for ANOVA
              switch (svalue(h$obj),
                      "multicore" = {
                        enabled(backendopts_layout[1,1]) <- TRUE
                        enabled(backendopts_layout[2,1]) <- TRUE
                        enabled(backendopts_layout[1,2]) <- FALSE
                        enabled(backendopts_layout[2,2]) <- FALSE
                        enabled(backendopts_layout[3,1]) <- FALSE
                        enabled(backendopts_layout[4,1]) <- FALSE
                      })
            })

backendopts_layout <- glayout(container = parallel_frame)
backendopts_layout[1,1] <- "# of Cores"

if (detectCores() < 2) { # single core case
    backendopts_layout[2,1] <-
        "Single core machine detected: multicore unavailable"
} else { 
    backendopts_layout[2,1] <- gslider(from = 1, to = detectCores(), by = 1,
                                       handler = function(h,...){
                                        # set number of cores
                                           rbci.env$numcores <- svalue(h$obj)
                                       })
}

# backendopts_layout[1,2] <- " "
# backendopts_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)
# 
# backendopts_layout[3,1] <- " "
# backendopts_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

enabled(backendopts_layout[1,1]) <- TRUE
enabled(backendopts_layout[2,1]) <- TRUE
enabled(backendopts_layout[1,2]) <- FALSE
enabled(backendopts_layout[2,2]) <- FALSE
enabled(backendopts_layout[3,1]) <- FALSE
enabled(backendopts_layout[4,1]) <- FALSE

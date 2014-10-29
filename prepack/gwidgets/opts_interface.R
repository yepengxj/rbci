window.width <- 1000
window.height <- 600

preview.rowlen <- 20

opts_win <- gwindow("Parallelization Options",
                    width = window.width,
                    height = window.height)

parallel_label <- glabel("Options")
parallelbackend_type_list <- c("multicore")

parallelbackend_type_menu <- 
  gdroplist(filter_type_list,
            text = "Backend Type",
            container = filter_param_frame,
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

backendopts_layout <- glayout(container = opts_win)
backendopts_layout[1,1] <- "# of Cores"
backendopts_layout[2,1] <- gspinbutton(from = 1, to = detectCores(), by = 1)

# stop band end
backendopts_layout[1,2] <- ""
backendopts_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
backendopts_layout[3,1] <- ""
backendopts_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

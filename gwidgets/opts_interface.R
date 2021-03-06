window.width <- 450
window.height <- 500

opts_win <- gwindow("Parallelization Options",
                    width = window.width,
                    height = window.height)

parallel_frame <- gframe(container = opts_win,
                         horizontal = FALSE)

parallel_label <- glabel("Cluster Type",
                         container = parallel_frame)
parallelbackend_type_list <- c("multicore (local)", "SNOW", "Redis")

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
                      "multicore (local)" = {
                          ## load multicore subGUI
                          source('./gwidgets/opts_interface_multicore.R') 
                      },
                      "SNOW" = {
                          ## load snow subGUI
                          source('./gwidgets/opts_interface_snow.R')
                      },
                      "Redis" = {
                          ## load redis subGUI
                          source('./gwidgets/opts_interface_redis.R')
                      })
            })
## since multicore is default and droplist handler won't run then, we manually
## call default subGUI
source('./gwidgets/opts_interface_multicore.R')

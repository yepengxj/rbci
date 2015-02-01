multicore_backendopts_frame <- gframe(horizontal = FALSE,
                                      text = "Multicore options")
## initialize lower layout again
if (exists('backendopts_frame') && isExtant(backendopts_frame)) {
    delete(parallel_frame,
           backendopts_frame)
}

add(parallel_frame, multicore_backendopts_frame)

backendopts_frame <- multicore_backendopts_frame # add simple name reference

numcores_label <- glabel("# of Cores",
                         container = backendopts_frame)


if (detectCores() < 2) { # single core case
    numcores_nope <- glabel(
        "Single core machine detected: multicore unavailable",
        container = backendopts_frame)
} else { 
    numcores_slider <- gslider(from = 1, to = detectCores(), by = 1,
                               handler = function(h,...){
                                        # set number of cores
                                   rbci.env$numcores <- svalue(h$obj)
                               })
}

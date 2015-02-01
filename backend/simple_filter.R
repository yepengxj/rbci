simple.filter <- function(filter.type,
                          active.band,
                          sample.rate,
                          filter.groups) {
#    filter.order <- 8 # TODO replace this with selectable order later
    band.tolerance <- 10 # Hz margin between pass/stop
    
    switch(filter.type,
           Lowpass = {
               pass.band <- active.band[[2]] # for the one-sided filters we use
                                             # only one frequency
               stop.band <- pass.band + band.tolerance
           },
           Highpass = {
               pass.band <- active.band[[1]]
           },
           Stopband = {
               stop.band <- active.band
               pass.band <- c(stop.band[[1]] - band.tolerance,
                              stop.band[[2]] + band.tolerance)              
           },
           Bandpass = {
               pass.band <- active.band
               stop.band <- c(pass.band[[1]] - band.tolerance,
                              pass.band[[2]] + band.tolerance)
           })
    
#    designed.filter <-
#        butter(filter.order, type = filt.type,
#               W = pass.band,
#               plane = "s")
    designed.filter <-
        butter(buttord(Wp = pass.band/sample.rate*2,
                       Ws = stop.band/sample.rate*2,
                       Rp = 0.5, Rs = 40)) # ripple doesn't matter so much for
                                           # butter
}

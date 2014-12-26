simple.filter <- function(filter.type,
                          filter.band,
                          filter.groups) {
    filter.order <- 8 # replace this with selectable order later?
    
    switch(filter.type,
           Lowpass = {
               filt.type <- "low"
               filt.band <- filter.band[2] # for the one-sided filters we use
                                           # only one frequency
           },
           Bandpass = {
               filt.type <- "pass"
               filt.band <- filter.band
           },
           Highpass = {
               filt.type <- "high"
               filt.band <- filter.band[1]
           },
           Stopband = {
               filt.type <- "stop"
               filt.band <- filter.band
           })
    
    designed.filter <-
        butter(filter.order, type = filt.type,
               W = filter.band,
               plane = "z")
}

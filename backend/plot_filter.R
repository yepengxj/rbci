plot.filter <- function(filter, sample.rate = 1,
                        active.band) {
    require(ggplot2)

                                                        
    filter.char <- freqz(filter, Fs = sample.rate)
    filter.char <- data.frame(freq = filter.char$f,
                              # conversion to decibels
                              mag = 20 * log10(abs(filter.char$h)))
    ## remove numerically erroneous values
    # filter.char[which(is.infinite(filter.char$mag)), ] <- NA

    ## make plotting window make sense
    active.band <- sort(active.band) 
    plot.freq.band <- c(max(c(active.band[[1]] - 10, 0)), # 10Hz margin between
                   min(c(active.band[[2]] + 10, sample.rate)))
    plot.mag.band <- c( # match the vertical axis by index of horizontal
        filter.char$mag[[max(which(filter.char$freq <= active.band[[1]]))]],
        filter.char$mag[[min(which(filter.char$freq >= active.band[[2]]))]])


    ggplot(filter.char, aes(x = freq, y = mag)) +
        scale_x_continuous(limits = range(plot.freq.band)) +
        scale_y_continuous(limits = range(plot.mag.band)) +
        geom_line() + 
        ggtitle(bquote("Magnitude Response of Applied Filter")) +
        xlab("Frequency (Hz)") +
        ylab("Amplitude (dB)")
}

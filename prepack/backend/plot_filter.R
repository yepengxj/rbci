plot.filter <- function(filter, sample.rate = 1) {
    require(ggplot2)
    
    filter.char <- freqz(filter, Fs = sample.rate)
    filter.char <- data.frame(freq = filter.char$f,
                              mag = 20 * log10( abs(filter.char$h ) ) )
    ## remove numerically erroneous values
    filter.char[which(is.infinite(filter.char$mag)),] <- NA

    ggplot(filter.char, aes(x = freq, y = mag)) +
        scale_x_continuous(limits = range(filter.char$freq)) +
        scale_y_continuous(limits = range(filter.char$mag)) +
        geom_line() + 
        ggtitle(bquote("Magnitude Response of Applied Filter")) +
        xlab("Frequency (Hz)") +
        ylab("Amplitude (dB)")
}

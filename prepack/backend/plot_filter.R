plot.filter <- function(filter, sample.rate = 1) {
    require(ggplot2)
    
    filter.char <- freqz(filter, Fs = sample.rate)
    filter.char <- data.frame(freq = filter.char$f,
                              mag = 20 * log10( abs(filter.char$h ) ) )

    ggplot(filter.char, aes(x = freq, y = mag)) + xlim(0,20) + ylim(-30,5) + 
        geom_line() + 
        ggtitle(bquote("Magnitude Response of Applied Filter")) +
        xlab("Frequency (Hz)") +
        ylab("Amplitude (dB)")
}

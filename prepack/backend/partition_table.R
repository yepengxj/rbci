partition.table <- function(table.data, part.col, proportions, part.type) {
### TODO error checking

    setkeyv(table.data, part.col) # speedup
    
    switch(part.type,
           "Sequential"={ 
               seq <- table.data[,unique(get(part.col))]
           },
           "Random"={
               seq <- sample(table.data[,unique(get(part.col))])
           })

    seq.parts <- subset.seq(seq, proportions)

    ## seq.parts is a list which we can use with lapply()
    ### TODO review this function for memory use
    lapply(seq.parts, function(x) {

        table.data[J(x)]
        
    })
}

### slices a sequence or into proportionate slices
### i.e., [0,1] fractional sizes given by slice.sizes
subset.seq <- function(sequence, slice.sizes) {
### TODO throw error if slice.sizes don't add up to 1

    ### TODO this feels clumsy, look for a cleverer and more readable way
    slice.sizes <- slice.sizes*length(sequence)
    slice.ends <- cumsum(slice.sizes)
    slice.starts <- c(1,slice.ends[1:length(slice.ends)-1]+1)

    ## the easy part
    mapply(function(x,y) {
        sequence[x:y]
    }, slice.starts, slice.ends)
### returns a list
}

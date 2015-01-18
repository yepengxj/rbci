apply.filter <- function(signal.table, filt.groups, val.col, filter.obj) {
    
    ## Parallelization: assume first group is largest, use foreach() and keyed
    ## table
    
    table.filtered <- copy(signal.table)
    setkeyv(table.filtered, filt.groups[[1]])

    if (getDoParRegistered()) { # parallel case
        foreach(this.group =
                    table.filtered[J(this.group),
                                   unique(get(filt.groups[[1]]))]) %dopar% {
                                       table.filtered[, c(val.col) :=
                                                          filtfilt(filter.obj,
                                                                   get(val.col)),
                                                      by = c(filt.groups[[2]])]
                                     } else {
                                     table.filtered <-
                                       table.filtered[, c(val.col) := filtfilt(filter.obj, get(val.col)),
                                                      by = filt.groups]
                                   }
                                     return(table.filtered)
    ### TODO examine reference dispatch in distributed context
}

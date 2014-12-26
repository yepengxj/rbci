apply.filter <- function(signal.table, filt.groups, val.col, filter.obj) {

    table.filtered <- copy(signal.table)
    table.filtered <-
        table.filtered[, get(val.col):=filtfilt(filter.obj, get(val.col)),
                       by = filt.groups]
    
}

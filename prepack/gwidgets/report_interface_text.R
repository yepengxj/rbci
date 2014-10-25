# elements:
# verbosity:
## output only
## parameters/plugin outputs
## all of the above and code
# format:
## raw
## Markdown
## knitted

text_pane <- gpanedgroup(horizontal = TRUE,
                              expand = TRUE,
                              fill = TRUE,
                              container = text_tab)

text_opts_frame <- gframe("Text Output Options",
                          horizontal = FALSE,
                          container = text_pane)

glabel("Verbosity", container = text_opts_frame)
verbosity_levels <- c("Output only", "Function I/O", "Full")
text_opts_verbose <- gdroplist(verbosity_levels,
                               container = text_opts_frame)

glabel("Format", container = text_opts_frame)
format_types <- c("Raw", "Markdown", "HTML")
text_opts_format <- gdroplist(format_types,
                              container = text_opts_frame)


addSpring(text_opts_frame)
text_reload_button <- gbutton("Update Preview",
                              container = text_opts_frame)

text_output_preview <- gtext("Output preview will appear here.",
                             container = text_pane,
                             expand = TRUE)
graphics_pane <- gpanedgroup(horizontal = TRUE,
                         expand = TRUE,
                         fill = TRUE,
                         container = graphics_tab)

graphics_opts_frame <- gframe("Output Options",
                          horizontal = FALSE,
                          container = graphics_pane)

glabel("Size", container = graphics_opts_frame)
graphics_opts_layout <- glayout(container = graphics_opts_frame)

# picture sizes
graphics_opts_layout[1,1] <- "Width"
graphics_opts_layout[2,1] <- gspinbutton(from = 200, to = 1920,
                                         by = 1, value = 320)

graphics_opts_layout[1,2] <- "Height"
graphics_opts_layout[2,2] <- gspinbutton(from = 200, to = 1080,
                                         by = 1, value = 240)

# graphic_opts_verbose <- gdroplist(verbosity_levels,
#                                container = graphic_opts_frame)
# 
# glabel("Format", container = graphic_opts_frame)
# format_types <- c("Raw", "Markdown", "HTML")
# graphic_opts_format <- gdroplist(format_types,
#                               container = graphic_opts_frame)

addSpring(graphics_opts_frame)
graphics_reload_button <- gbutton("Update Preview",
                              container = graphics_opts_frame)

graphics_output_preview <- ggraphics(container = graphics_pane,
                             expand = TRUE)
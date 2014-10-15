# button pane
pca_pane <- gpanedgroup(horizontal = TRUE,
                        expand = TRUE,
                        fill = TRUE,
                        container = trans_pca_tab)


pca_varlist_frame <- gframe(text = "Data Columns",
                            horizontal = FALSE,
                            container = pca_pane,
                            expand = TRUE,
                            width = 300)
# populate varlist
pca_varlist <- gcheckboxgroup(
  names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]),
  container = pca_varlist_frame,
  use.table = TRUE,
  expand = TRUE)

pca_action_pane <- gpanedgroup(horizontal = TRUE,
                               expand = TRUE,
                               fill = TRUE,
                               container = pca_pane)


## pca params
pca_param_frame <- gframe(text = "PCA Parameters",
                          horizontal = FALSE,
                          container = pca_action_pane,
                          expand = TRUE,
                          width = 300)

## opts
pca_kernel_type_list <- c("Linear","Polynomial","Laplacian","Gaussian")
pca_kernel_type_label <- glabel(text = "Kernel Type",
                                container = pca_param_frame)
pca_kernel_type_menu <- 
  gdroplist(pca_kernel_type_list,
            text = "Kernel Type",
            container = pca_param_frame,
            handler = function (h,...) {
              # enable or disable param GUI opts on type change
              # set param names!!
            })

# numerical entries (spinboxes)
pca_band_label <- glabel(text = "Numerical Parameters",
                         container = pca_param_frame)
pca_band_layout <- glayout(container = pca_param_frame)

# stop band start
pca_band_layout[1,1] <- "Stopband Start"
pca_band_layout[2,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# stop band end
pca_band_layout[1,2] <- "Stopband End"
pca_band_layout[2,2] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band start
pca_band_layout[3,1] <- "Passband Start"
pca_band_layout[4,1] <- gspinbutton(from = 0, to = 1, by = 0.01)

# pass band end
pca_band_layout[3,2] <- "Passband End"
pca_band_layout[4,2] <- gspinbutton(from = 0, to = 1, by = 0.01)


## application params
pca_grouping_frame <- gframe(text = "Transform Apply Rules",
                             horizontal = FALSE,
                             container = pca_param_frame,
                             expand = TRUE,
                             width = 300)
# trial/group vars
pca_grouping_label <- glabel(text = "Data Grouping",
                             container = pca_grouping_frame)
pca_grouping_layout <- glayout(container = pca_grouping_frame)

pca_grouping_layout[1,1] <- "First Group (Trial)"
pca_grouping_layout[2,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

pca_grouping_layout[3,1] <- "Second Group (Channel)"
pca_grouping_layout[4,1] <- 
  gcombobox(
    names(rbci.env$importlist[[svalue(trans_var_filesel, index=TRUE)]]))

## output params
pca_output_frame <- gframe(text = "KL Output Options",
                           horizontal = FALSE,
                           container = pca_param_frame,
                           expand = TRUE,
                           width = 300)

# apply pca button
pca_apply_btn <- gbutton("Apply KL to Data",
                         container = pca_output_frame)

# save pca
pca_save_btn <- gbutton("Save KL Data",
                        container = pca_output_frame)
# refresh dataset frame on run
# alert complete (progress bar?)


# plot pane

# pca plot on right side
pca_plot_frame <- ggraphics(container = pca_action_pane)

# set some widths (doesn't work if earlier)
svalue(pca_param_frame) <- 0.2
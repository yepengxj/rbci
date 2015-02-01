# r.bci #

## Overview

This is a small project to build an R-based free+open-source cross-platform GUI
tool for brain-computer interface research, like that of EEGLAB or BCILAB, to
accomplish the main tasks of data science therein (adapted from
[Ricky Ho's article on the subject](http://horicky.blogspot.de/2013/08/six-steps-in-data-science.html)):

1. Data acquisition
2. Data visualization
3. Preprocessing algorithm design
4. Classification
5. Report generation

### Other goals

- Specific, well-defined formats and data structures for EEG data (especially
  taking advantage of [data.table](https://github.com/Rdatatable/data.table)
- Cross-platform support through GTK
- Improved visualizations (adding to the already excellent ones in R)
- Increased collaboration and reproducibility through free+open software

## Features

- Modules for each of the above tasks, and more:
    - Import
        - MATLAB
        - RData
        - CSV
    - Filtering
    - Downsampling
    - Exploration
        - Histograms
        - Summary stats
        - Grand means
        - Data partitioning
    - Transforms
        - PCA
        - CSP
    - Unsupervised learning
        - k-means
    - Supervised learning
        - SDA
        - SVM
        - Naive Bayes
    - Report generation
        - Automatic code generation
        - Literate programming (with `knitr`)

## Current status

Approaching v0.1 rapidly.

### How to build and run

- Note: that this is experimental software and has only been tested on 64-bit
Linux. If you have problems, please include a `traceback()` and your system
information in an issue.

#### Requirements:

- You should have the latest version of R (tested on Pumpkin Helmet, amd64
  Linux).
- Make sure you have a copy of GTK2, including development headers
  (`libgtk2.0-dev` for Linux users)
- For MPI-based parallelism, you will need OpenMPI development headers and
  binaries (`libopenmpi-dev`, `openmpi-bin`)
- May also require `curl` as RCurl depends on it (specifically,
  `libcurl4-gnutls-dev`).

#### Running rBCI

The rest of the packages should install through R when run:

	git clone https://github.com/talexand/rbci.git
	cd rbci
	R
	source('./gwidgets/init_interface.R')

## Why not just use *LAB? ##

1. EEGLAB and BCILAB contain a *lot* of great work that represents the combined
   effort of many highly skilled researchers, and they are extremely easy to use
   in a properly configured software/hardware environment. However, both
   toolboxes depend heavily on a proprietary platform, namely MATLAB, whose
   idiosyncratic syntax, large footprint, and high price (2000 USD as of this
   writing) present hurdles to learning, building, and applying ideas and
   techniques, both new and old, to a fast-growing research area. An R
   implementation has the potential to help connect a large portion of the data
   science/machine learning community to the field of BCI and even accelerate
   things by taking advantage of the vast number of actively developed, freely
   available software packages (I'm looking at you, expensive MATLAB Parallel
   Toolbox.)

2. It's true that there are already a number of great GUI libraries for data
   science in R, for example, Rattle. However, after two years of research, I
   have found none aimed squarely at the task types and data structures that are
   ubiquitous in, for example, EEG research. (A great example of this is epoched
   multivariate time series.)

3. EEGLAB and BCILAB don't support parallelism or distributed computing.



### Roadmap

See the issues page for tickets marked 'enhancement'.

### Wishlist

- stream input for online algorithms from BCI2000 (incorporating
  [rstreamBCI](https://github.com/talexand/rstreambci))
- Complete replication of most popular algorithms from EEGLAB, BCILAB, SIFT,
  etc.
- Core code written entirely in fast precompiled languages (C, C++)
- Interface to wavelet tools
- Additional report generation features like
    - AUC analysis in feature space
- Modular tool format so that interface components can be swapped in and out of
  chain (like bci2000)

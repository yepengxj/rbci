# r.bci #

## Overview
This is a small project to build an R-based free+open-source cross-platform GUI tool for brain-computer interface research, like that of EEGLAB or BCILAB, to accomplish the main tasks of data science therein (adapted from [Ricky Ho's article on the subject](http://horicky.blogspot.de/2013/08/six-steps-in-data-science.html)):

1. Data acquisition
2. Data visualization
3. Preprocessing algorithm design
4. Classification/
5. Report generation

### Why bother?
1. EEGLAB and BCILAB contain a *lot* of great work that represents the combined effort of many highly skilled researchers, and they are extremely easy to use in a properly configured software/hardware environment. However, both toolboxes depend heavily on a proprietary platform, namely MATLAB, whose idiosyncratic syntax, large footprint, and high price present hurdles to learning, building, and applying ideas and techniques, both new and old, to a fast-growing research area. An R implementation has the potential to help connect a large portion of the data science/machine learning community to the field of BCI and even accelerate things by taking advantage of the vast number of actively developed, freely available software packages (I'm looking at you, non-free MATLAB Parallel Toolbox).

2. It is true that there are already a number of great GUI libraries for data science in R, for example, Rattle. However, after a year of research, I have found none aimed squarely at the task types and data structures that are ubiquitous in, for example, EEG research. (A great example of this is epoched multivariate time series.)

## Goals
While the wishlist is long, the immediate goals are as follows.

- Interoperability with bci2000
    - static data import/export
    - stream input for online algorithms (actually the subject of the [RstreamBCI library](projecturlhere))
- Data converters to/from EEGLAB, BCILAB and MATLAB
    - static data import/export (both epoched and continuous)
- Interface (by task)
    - Data exploration
        - Subsetting by time/channel
        - Common visualization tasks
        - Statistical summary report generation
    - Custom algorithm/processing chain design tool
        - Guided interface
        - Script-based
    - Transformation/unsupervised learning suite
        - PCA
            - Linear
            - Kernel
        - EMD
        - ICA
        - *k*-means
        - Hierarchical clustering
    - Classification/supervised learning suite
        - Classic algorithms
            - LDA
            - SWLDA
            - SVM
                - Kernel
                - Linear (for large datasets)
        - Parallelization interface for classification/hyperparameter optimization
    - Report generation/editing
        - Guided template design
        - Direct configuration of RMarkdown files

Some of these tasks are already more or less complete--I just have to extract them from my own R code and make them more user-friendly. Many are easily done by bringing in other existing community R packages.

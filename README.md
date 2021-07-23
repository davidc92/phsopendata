![example workflow](https://github.com/davidc92/phsopendata/actions/workflows/r.yml/badge.svg)
<!-- README.md is generated from README.Rmd. Please edit that file -->
phsopendata
===========

<!-- badges: start -->
<!-- badges: end -->
`phsopendata` contains functions to interact with open data from the [Scottish Health and Social Care Open Data platform](https://www.opendata.nhs.scot/) via the CKAN API.

-   `get-resource` extracts a single resource from an open dataset by resource id
-   `get-dataset` extracts multiple resources from an open dataset by dataset name

For extracting metadata and search functionality, we recommend using the [ckanr package](https://docs.ropensci.org/ckanr/).

`phsopendata` can be used on both the [server](https://rstudio.nhsnss.scot.nhs.uk/) and desktop versions of RStudio. However, depending on firewall settings, proxy use may need to be configured with use\_proxy().

Installation
------------

To install `phsopendata`, the package `remotes` is required, and can be installed with `install.packages("remotes")`.

You can then install `phsopendata` on RStudio server from GitHub with:

``` r
remotes::install_github("Public-Health-Scotland/phsopendata",
  upgrade = "never"
)
```

Examples
--------

### get\_resource

To extract a specific resource, you will need it\`s unique identifier - resource id. This can be found in the dataset metadata by visiting the website, or extracted using ckanr::package\_show.

``` r
library(phsopendata)

#by default the full resource is returned
opendata_get_resource(res_id = "a794d603-95ab-4309-8c92-b48970478c14")

#but you can set the number of rows to return
opendata_get_resource(res_id = "a794d603-95ab-4309-8c92-b48970478c14", rows = 10)
```

### get\_dataset

To extract all resources from a dataset, you will need to use the dataset name. Note that this will differ from the dataset Title that displays on the website. This can be found in the dataset metadata extracted using ckanr::package\_show, or taken from the dataset URL.

In this example, we are downloading GP Practice Population Demographics from: opendata.nhs.scot/dataset/gp-practice-populations, so the dataset name will be gp-practice-populations.

``` r
#if max_resources is not set, all resources will be returned by default. 
#Here we pull 10 rows from the first 2 resources only
opendata_get_dataset("gp-practice-populations", max_resources = 2, rows = 10)
```

Contributing to phsopendata
---------------------------

At present, this package is maintained by [Csilla Scharle](https://github.com/csillasch).

If you have requests or suggestions for additional functionality, please contact the package maintainer and/or the [PHS Open Data team](phs.opendata@phs.scot).

If you would like to share examples of how you work with open data, you can also do so in the <https://github.com/Public-Health-Scotland/Open-Data> repository, where example scripts and resources are collated.

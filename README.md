
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{rpt}` (<u>R</u> <u>p</u>ackage <u>t</u>emplate)

<!-- badges: start -->

[![R-CMD-check](https://github.com/UCD-SERG/rpt/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/UCD-SERG/rpt/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/UCD-SERG/rpt/graph/badge.svg)](https://app.codecov.io/gh/UCD-SERG/rpt)
[![CodeFactor](https://www.codefactor.io/repository/github/ucd-serg/rpt/badge)](https://www.codefactor.io/repository/github/ucd-serg/rpt)
[![CRAN
status](https://www.r-pkg.org/badges/version/rpt)](https://CRAN.R-project.org/package=rpt)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `{rpt}` is to …

## Installation

You can install the development version of `{rpt}` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("UCD-SERG/rpt")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(rpt)
## basic example code
```

## Development

### Building the pkgdown Site

When building the pkgdown documentation site with
`pkgdown::build_site()`, the function needs to download external
JavaScript and CSS dependencies from CDNs (Content Delivery Networks).
If you’re working in a restricted network environment, you’ll need to
ensure access to the following CDNs:

- `https://cdnjs.cloudflare.com/` - For headroom.js (sticky header
  functionality)
- `https://cdn.jsdelivr.net/` - For bootstrap-toc.js (table of contents)
  and other Bootstrap dependencies

Without access to these CDNs, `pkgdown::build_site()` will fail with
errors like:

    Error: cannot open URL 'https://cdnjs.cloudflare.com/ajax/libs/headroom/0.11.0/headroom.min.js'

These dependencies are automatically cached after the first download, so
subsequent builds will be faster and won’t require network access unless
the cache is cleared.

## Other R Package Template Options

If you’re looking for alternative R package templates, you may also want
to consider:

- [r.pkg.template](https://github.com/insightsengineering/r.pkg.template/) -
  A comprehensive R package template from Insights Engineering

## Code of Conduct

Please note that the `{rpt}` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

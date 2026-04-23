
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{pr.helpers}` (PR helpers package)

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/d-morrison/pr.helpers/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/d-morrison/pr.helpers/actions)
[![Codecov test
coverage](https://codecov.io/gh/d-morrison/pr.helpers/branch/main/graph/badge.svg)](https://app.codecov.io/gh/d-morrison/pr.helpers)
[![CodeFactor](https://www.codefactor.io/repository/github/d-morrison/pr.helpers/badge)](https://www.codefactor.io/repository/github/d-morrison/pr.helpers)
[![CRAN
status](https://www.r-pkg.org/badges/version/pr.helpers)](https://cran.r-project.org/package=pr.helpers)
[![](http://cranlogs.r-pkg.org/badges/grand-total/pr.helpers)](https://cran.r-project.org/package=pr.helpers)
[![](http://cranlogs.r-pkg.org/badges/last-month/pr.helpers)](https://cran.r-project.org/package=pr.helpers)
[![](http://cranlogs.r-pkg.org/badges/last-week/pr.helpers)](https://cran.r-project.org/package=pr.helpers)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)

<!-- badges: end -->

`{pr.helpers}` streamlines common pull request (GitHub) and merge
request (GitLab) workflows from the command line in an R session.

## Installation

You can install the development version of `{pr.helpers}` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("d-morrison/pr.helpers")
```

## Example

This example builds a pull request URL for a feature branch:

``` r
library(pr.helpers)
pr_request_url(
  "https://github.com/acme/widgets.git",
  source_branch = "feature/new-report",
  target_branch = "main"
)
#> [1] "https://github.com/acme/widgets/compare/main...feature%2Fnew-report?expand=1"
```

## Development

### Building the Documentation Site

This package uses [altdoc](https://altdoc.etiennebacher.com/) with
[Quarto](https://quarto.org/) to build its documentation site. To build
and preview the documentation locally:

``` r
# Load the package
pkgload::load_all()

# Render the documentation
altdoc::render_docs()

# Preview the site
altdoc::preview_docs()
```

The documentation is automatically built and deployed to GitHub Pages
via GitHub Actions when changes are pushed to the main branch.

## Code of Conduct

Please note that the `{pr.helpers}` project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

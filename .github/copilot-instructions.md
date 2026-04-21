# Copilot Instructions for R Package Template

## Repository Overview

This is a template repository for creating R packages following UCD-SERG standards.

- **Type**: R package template
- **Language**: R (>= 4.1.0)
- **Key Dependencies**: See DESCRIPTION file

## Setup Requirements

### Copilot Setup Workflow

The repository includes a `.github/workflows/copilot-setup-steps.yml` workflow that automatically configures the GitHub Copilot coding agent's environment with all required dependencies.

#### What the Workflow Does

1. Installs system dependencies (libcurl, libssl, libxml2, graphics libraries)
2. Sets up R (>= 4.1.0)
3. Installs R package dependencies
4. Verifies installation

#### When to Use This Template

1. Clone or use this repository as a template
2. Replace all instances of `packagename` with your actual package name
3. Update DESCRIPTION, README.Rmd, and other files with your package details
4. Add your R functions to `R/` directory
5. Add tests to `tests/testthat/` directory
6. Run `devtools::document()` to generate documentation
7. Run `devtools::check()` to validate your package

## Version Management

**CRITICAL**: When creating a new branch or PR from main, ALWAYS increment the development version number in the DESCRIPTION file to one version past the current main branch version.

For example:
- If main branch has version `0.0.0.9005`
- Your new branch MUST have version `0.0.0.9006`

This ensures that package versions remain unique across branches and prevents version conflicts.

**Before finishing each coding session**: Fetch the main branch and increment the development version if your branch is not ahead of main, before committing and requesting review again.

## Development Workflow

### Building and Checking

```r
# Install development dependencies
devtools::install_dev_deps()

# Generate documentation
devtools::document()

# Run R CMD check
devtools::check()

# Run tests
devtools::test()

# Build package
devtools::build()
```

### Linting

```r
# Lint the package
lintr::lint_package()
```

### Testing

```r
# Run all tests
devtools::test()

# Run specific test file
devtools::test_file("tests/testthat/test-example_function.R")

# Run tests with coverage
covr::package_coverage()
```

## Local Validation Requirements

**CRITICAL**: Before committing any code changes or requesting review, ALWAYS run the following validation commands locally:

1. **`lintr::lint_package()`** - Check code style and identify linting issues
2. **`devtools::document()`** - Generate/update documentation from roxygen2 comments
3. **`devtools::test()`** - Run all test suites to ensure tests pass
4. **`devtools::check()`** - Run R CMD check to validate package structure and compliance
5. **`pkgdown::build_site()`** - **MANDATORY**: Build the full pkgdown website locally and inspect the output to ensure all documentation renders correctly, including vignettes, articles, and any special formats (e.g., RevealJS presentations)

These commands must be run in this order and all must pass without errors before pushing changes or requesting code review. This ensures that CI/CD workflows will pass and prevents wasting reviewer time on fixable issues.

**IMPORTANT**: For changes affecting documentation or vignettes, you MUST build and visually inspect the pkgdown site output (located in `docs/`) to verify that everything renders as expected. This is especially critical for multi-format documents or custom output formats.

### Example Validation Workflow

```r
# Complete validation sequence before committing
devtools::document()    # Update documentation
devtools::test()        # Verify all tests pass
devtools::check()       # Run full package check
lintr::lint_package()   # Verify code style
pkgdown::build_site()   # Build pkgdown site to verify documentation

# Manually inspect docs/ directory to verify rendering
# Check docs/articles/*.html for correct output
# Verify links, images, and special formats work correctly

# Only commit and push if all checks pass AND visual inspection confirms correct rendering
```

## Package Structure

- `R/` - R source files
- `tests/testthat/` - Unit tests
- `man/` - Documentation (auto-generated)
- `vignettes/` - Long-form documentation
- `data/` - Package data
- `data-raw/` - Scripts to generate package data
- `inst/` - Additional files to include in the package
- `.github/` - GitHub Actions workflows and templates

## Code Style

- Follow the [tidyverse style guide](https://style.tidyverse.org)
- Use roxygen2 for documentation
- Include tests for all exported functions
- Update NEWS.md for user-facing changes
  - Use the `(#issue_number)` notation to link to issues (e.g., `(#123)`)
  - Use the `(#PR_number)` notation to link to pull requests
  - Use `@username` to credit **external** contributors only (not internal team members)
  - See [R Packages - NEWS.md](https://r-pkgs.org/other-markdown.html#sec-news) for details

### Using Pipes to Emphasize Primary Inputs

Use pipes (`|>` or `%>%`) to emphasize the primary input and make sequences of actions more readable:

- **Use pipes for sequences**: When applying multiple transformations to a single primary object (typically a data frame), use pipes to show the flow of data through the transformations
- **Emphasize the main subject**: Pipes keep the focus on the primary input by placing it at the start of the pipeline
- **Avoid for multiple objects**: Don't use pipes when multiple unrelated objects are involved; use direct function calls or intermediate variables instead
- **Formatting**: 
  - Add a space before the pipe operator
  - Place each step on a new line for multi-step pipelines
  - Indent continuation lines for clarity

**Example:**

```r
# Good: Pipe emphasizes the primary input (iris) and the sequence of transformations
iris |>
  summarize(across(where(is.numeric), mean), .by = Species) |>
  pivot_longer(!Species, names_to = "measure", values_to = "value") |>
  arrange(value)

# Less clear: Nested functions obscure the flow
arrange(
  pivot_longer(
    summarize(iris, across(where(is.numeric), mean), .by = Species),
    !Species, names_to = "measure", values_to = "value"
  ),
  value
)
```

For more details, see the [tidyverse style guide on pipes](https://style.tidyverse.org/pipes.html).

## UCD-SERG Lab Manual

Follow the guidance provided in the [UCD-SERG Lab Manual](https://ucd-serg.github.io/lab-manual/). The corresponding source files are available at [github.com/UCD-SERG/lab-manual](https://github.com/UCD-SERG/lab-manual) if easier to read.

## Continuous Integration

The template includes GitHub Actions workflows for:
- R-CMD-check on multiple platforms
- Test coverage reporting
- pkgdown documentation deployment
- Spell checking
- Linting
- Version checking
- NEWS.md changelog checking

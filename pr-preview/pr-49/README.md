# Quarto Build Optimization

This directory contains Quarto configuration files to optimize documentation builds.

## Overview

The repository uses multiple Quarto output formats for vignettes:
- **HTML**: For the website
- **RevealJS**: For presentations
- **DOCX**: For Word documents
- **PPTX**: For PowerPoint presentations

However, when building the website in CI/CD, only HTML format is needed. Rendering all formats significantly increases build time (15+ minutes).

## Optimization Strategy

We use two complementary approaches to speed up builds:

### 1. Quarto Profiles (Experimental)

Quarto's profile feature allows conditional configurations:

- **Default Profile** (Local Development)
  - Files: `_quarto.yml` and `vignettes/_metadata.yml`
  - Renders all formats (HTML, RevealJS, DOCX, PPTX)
  - Used when running `quarto render` locally

- **Website Profile** (CI/CD)
  - Files: `_quarto-website.yml` and `vignettes/_metadata-website.yml`
  - Configured to prioritize HTML-only rendering
  - Activated in CI by setting `QUARTO_PROFILE=website`

**Note**: Due to Quarto's configuration merge behavior, individual vignette format specifications may still be processed. The profile provides a hint to Quarto about the intended output, which may help with rendering optimization.

### 2. Freeze Functionality

The workflow uses altdoc's freeze feature to cache rendered content:

- Unchanged vignettes are skipped on subsequent builds
- Freeze state stored in `altdoc/freeze.rds` (cached via GitHub Actions)
- Significantly reduces build time when only some files change

## Usage

### Local Development
```bash
# Render all formats (default)
quarto render

# Or explicitly use default profile
QUARTO_PROFILE=default quarto render
```

### Website Builds (CI/CD)
```bash
# Use website profile (automatically set in GitHub Actions)
QUARTO_PROFILE=website quarto render
```

The GitHub Actions workflow automatically sets `QUARTO_PROFILE=website` to optimize builds.

## Performance Improvements

With these optimizations:
- **Freeze caching**: Only changed content is re-rendered
- **Workflow caching**: Freeze state persists across runs
- **Selective triggers**: Only runs when documentation files change
- **Profile hints**: Attempts to prioritize HTML format

Expected improvement: 2-4x faster builds depending on the number of unchanged files.

## Additional Notes

Individual vignette files may still specify multiple formats in their YAML frontmatter. The Quarto profile system will merge these configurations. If further optimization is needed, consider removing non-HTML formats from individual vignette files during CI builds using a preprocessing step.

## References

- [Quarto Profiles Documentation](https://quarto.org/docs/projects/profiles.html)
- [altdoc Package](https://altdoc.etiennebacher.com/)
- [altdoc Freeze Documentation](https://altdoc.etiennebacher.com/#/man/render_docs.md)


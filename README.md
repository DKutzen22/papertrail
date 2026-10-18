# Papertrail - Resume as Code

A reproducible Resume and CV combo built with [Quarto](https://quarto.org/) and rendered to PDF with [Typst](https://typst.app/).

The resume content lives in `.yml` files in the `/data` directory, making it easy to maintain in Git, tailor for different applications, and regenerate without manually editing a PDF.

## Requirements

Install Quarto:

- [Quarto installation instructions](https://quarto.org/docs/get-started/)

Quarto includes support for rendering Typst-based PDF documents. No full LaTeX installation is required.

To verify your installation:

```bash
quarto check
```

## Project Structure

```text
.
├── _quarto.yml                    # Project-level Quarto configuration       
├── 00-formatters.typ              # Typst file that defines formatting functions
├── 01-cv.qmd                      # CV master document (multi-page, comprehensive)
├── 02-resume.qmd                  # Resume master document (1-page, focused)
├── data/                          # Modular .yml files with all relevant info
│   ├── 00-example-experiences.yml # Example formatting for the render-experiences function
│   ├── 01-example-research.yml    # Example formatting for the render-research function
│   ├── 02-example-skills.yml      # Example formatting for the render-skills function
│   ├── 03-example-awards.yml      # Example formatting for the render-awards function
│   ├── education.yml
│   ├── experience.yml
│   ├── publications.yml
│   ├── presentations.yml        
│   ├── projects.yml
│   ├── skills.yml 
│   ├── leadership.yml
│   └── awards.yml
├── README.md                      # Project documentation
└── output/                        # Rendered PDFs
    ├── {name}-Resume.pdf
    └── {name}-CV.pdf
```

## Change the File Name

Edit the YAML front matter at the top of `01-cv.qmd` or `02-resume.qmd`:

```yaml
***
output-file: "Dalton_Kutzen-Resume"
***
```

- `output-file` controls the generated PDF filename.

For example:

```yaml
output-file: "Dalton_Kutzen-IT-Resume"
```

will generate:

```text
output/Dalton_Kutzen-IT-Resume.pdf
```

### Use Markdown in display fields

The shared `prep()` function converts fields selected through `markdown-fields` into Typst content.

For example, when `title` and `description` are selected for conversion:

```yaml
- title: "[Phantom — Bacteriophage Analysis Workflow](https://github.com/dkutzen22/phantom)"
  details: "A **reproducible** workflow for *bacteriophage* genome analysis."
  show_in: [resume, cv]
```

will generate:


> ***[Phantom — Bacteriophage Analysis Workflow](https://github.com/dkutzen22/phantom)***
> - A **reproducible** workflow for *bacteriophage* genome analysis.

All fields except show_in are converted by default.

Supported formatting includes Markdown emphasis and links:

```text
*italic*
**bold**
[link text](https://example.com)
```

### Quote YAML text safely

As a project convention, quote single-line display text:

```yaml
description: "Tools: Python, R, and Bash"
```

For Markdown links, quote the whole value but not the URL inside the link:

```yaml
title: "[Phantom](https://github.com/dkutzen22/phantom)"
```

For longer text, use a folded block:

```yaml
description: >-
  Developed a **reproducible workflow** for bacteriophage
  genome analysis using Snakemake and Conda.
```

Keep actual numbers and booleans unquoted when their data types matter:

```yaml
order: 1
enabled: true
```

## Formatting Functions

`00-formatters.typ` contains reusable helpers for preparing and rendering content.

The shared preparation workflow:

1. Loads a YAML file.
2. Filters entries by document target.
3. Converts selected Markdown fields to Typst content.
4. Returns the section heading and prepared entries.

A section can then be rendered from a raw Typst block in a `.qmd` document:

```{=typst}
#import "00-formatters.typ": *

#let data-dir = "data"
#let doc = "cv"

#render-experiences(
  title: "Education",
  path: data-dir + "/education.yml",
  target: doc,
)
```

Use `"resume"` as the target in the résumé document.

### Select which documents include an entry

Use `show_in` to control whether an entry appears in the résumé, CV, or both:

```yaml
show_in: [resume, cv]
```

CV only:

```yaml
show_in: [cv]
```

Résumé only:

```yaml
show_in: [resume]
```

The shared `prep()` function filters entries using the target supplied by the document. Entries without `show_in` default to CV-only inclusion.

## Render Documents

From the project directory, run:

```bash
# Render both Resume and CV
quarto render

# Or render individually:
quarto render 01-cv.qmd --to typst
quarto render 02-resume.qmd --to typst
```

The rendered PDFs are saved to:

```text
output/{name}-Resume.pdf
output/{name}-CV.pdf
```

The output directory and file title are configured in `_quarto.yml`.


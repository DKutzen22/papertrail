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
├── _quarto.yml                 # Project-level Quarto configuration       
├── 00-formatters.typ           # Typst file that defines formatting functions
├── 01-cv.qmd                   # CV master document (multi-page, comprehensive)
├── 02-resume.qmd               # Resume master document (1-page, focused)
├── data/                       # Modular .yml files with all relevant info
│   ├── example-experiences.yml # Example formatting for the render-experiences function
│   ├── example-research.yml    # Example formatting for the render-research function
│   ├── example-skills.yml      # Example formatting for the render-skills function
│   ├── example-awards.yml      # Example formatting for the render-awards function
│   ├── awards.yml
│   ├── education.yml
│   ├── experience.yml
│   ├── leadership.yml
│   ├── presentations.yml        
│   ├── projects.yml
│   ├── publications.yml
│   └── skills.yml 
├── README.md                   # Project documentation
└── output/                     # Rendered PDFs
    ├── Dalton_Kutzen-Resume.pdf
    └── Dalton_Kutzen-CV.pdf
```

## Configuration

### Candidate Details & Contact Information

Project-wide identity and contact links are configured in `_quarto.yml`:

```yaml
title: "Dalton Kutzen"
format:
  typst:
    papersize: us-letter
    linkcolor: "#1F4E79"

config:
  data-dir: "data"
  email: "dalton@kutzen.org"
  github: "dkutzen22"
  linkedin: "daltonkutzen"
```

- `title` sets the header name displayed at the top of both the CV and résumé.
- `config.email`, `config.github`, and `config.linkedin` are used by `#render-contact()` in `00-formatters.typ` to build the hyperlinked contact row.

### Change the Output File Name

Edit the YAML front matter at the top of `01-cv.qmd` or `02-resume.qmd`:

```yaml
---
output-file: "Dalton_Kutzen-Resume"
---
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

### Use Markdown in Display Fields

The shared `prep()` function converts fields selected through `markdown-fields` into Typst content.

For example, when `title` and `details` are converted:

```yaml
- title: "[Phantom — Bacteriophage Analysis Workflow](https://github.com/dkutzen22/phantom)"
  details:
    - "Modular Snakemake pipeline for phage genome annotation and downstream comparative analysis."
  show_in: [resume, cv]
```

will generate:

> ***[Phantom — Bacteriophage Analysis Workflow](https://github.com/dkutzen22/phantom)***
> - Modular Snakemake pipeline for phage genome annotation and downstream comparative analysis.

All display fields except `show_in` are converted by default.

Supported formatting includes Markdown emphasis and links:

```text
*italic*
**bold**
[link text](https://example.com)
```

### Quote YAML Text Safely

As a project convention, quote single-line display text:

```yaml
organization: "Terooatea Lab, Brigham Young University"
```

For Markdown links, quote the whole value:

```yaml
title: "[Phantom — Bacteriophage Analysis Workflow](https://github.com/dkutzen22/phantom)"
```

For longer text, use a folded block:

```yaml
details:
  - >-
    Modular Snakemake pipeline for phage genome annotation
    and downstream comparative analysis.
```

Keep actual numbers and booleans unquoted when their data types matter:

```yaml
order: 1
enabled: true
```

## Formatting Functions

`00-formatters.typ` contains reusable helpers for preparing and rendering content:

- `#render-contact()`: Renders email, GitHub, and LinkedIn links.
- `#render-experiences()`: Renders education, work experience, projects, or leadership entries.
- `#render-research()`: Renders publications, preprints, and presentations.
- `#render-skills()`: Renders categorized skill lists.
- `#render-awards()`: Renders honors and awards.

The shared preparation workflow:

1. Loads a YAML file from `data-dir`.
2. Filters entries by document target (`"resume"` vs `"cv"`).
3. Converts selected Markdown fields to Typst content.
4. Returns the section heading and prepared entries.

A section can be rendered from a raw Typst block in a `.qmd` document:

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

### Select Which Documents Include an Entry

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
output/Dalton_Kutzen-Resume.pdf
output/Dalton_Kutzen-CV.pdf
```

The output directory is configured under `project.output-dir` in `_quarto.yml`.

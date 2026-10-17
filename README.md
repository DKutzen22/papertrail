# Dalton Kutzen - Resume & CV

A reproducible resume built with [Quarto](https://quarto.org/) and rendered to PDF with [Typst](https://typst.app/).

The resume content lives in a plain-text `.qmd` file, making it easy to maintain in Git, tailor for different applications, and regenerate without manually editing a PDF.

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
├── _quarto.yml              # Project-level Quarto configuration          
├── resume.qmd               # Resume master document (1-page, focused)
├── cv.qmd                   # CV master document (multi-page, comprehensive)
├── sections/                # Modular section partials
│   ├── _contact.qmd         # Contact info (shared)
│   ├── _education.qmd       # Education (shared)
│   ├── _experience.qmd      # Work / research experience (shared)
│   ├── _projects.qmd        # Selected projects (shared)
│   ├── _skills.qmd          # Technical skills (shared)
│   ├── _leadership.qmd      # Leadership & activities (shared)
│   ├── _publications.qmd    # Publications & preprints (CV)
│   ├── _presentations.qmd   # Talks & posters (CV)
│   └── _awards.qmd          # Honors & awards (CV)
├── README.md                # Project documentation
└── output/                  # Rendered PDFs
    ├── Dalton Kutzen-Resume.pdf
    └── Dalton Kutzen-CV.pdf
```

## Render Documents

From the project directory, run:

```bash
# Render both Resume and CV
quarto render

# Or render individually:
quarto render resume.qmd --to typst
quarto render cv.qmd --to typst
```

The rendered PDFs are saved to:

```text
output/Dalton_Kutzen-Resume.pdf
output/Dalton_Kutzen-CV.pdf
```

The output directory is configured in `_quarto.yml`.

## Preview in Positron

To preview the document in Positron:

1. Open `resume.qmd`.
2. Open the Command Palette with `Ctrl+Shift+P`.
3. Run **Quarto: Preview Format**.
4. Choose **Typst** or **PDF**.

For a final build without live preview, use **Quarto: Render Document** or run the render command in Positron’s integrated terminal.

## Change the Displayed Name

Edit the YAML front matter at the top of `resume.qmd`:

```yaml
***
title: "Dalton Kutzen"
output-file: "Dalton_Kutzen-Resume"
***
```

- `title` controls the name displayed at the top of the document.
- `output-file` controls the generated PDF filename.

For example:

```yaml
output-file: "Dalton_Kutzen-Bioinformatics-Resume"
```

will generate:

```text
output/Dalton_Kutzen-Bioinformatics-Resume.pdf
```

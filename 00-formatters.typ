// formatters.typ - Reusable Typst layout and YAML rendering engine

// Sets accent color to blue
#let accent-color = rgb("#1F4E79")

//pulls config from _quarto.yml
#let settings = yaml("_quarto.yml")
#let config = settings.at("config")
#let data-dir = config.at("data-dir")

// Condenses spacing of the file heading
#let heading-style(body) = {
  show heading.where(level: 1): it => block(
    width: 100%,
    above: 1em,
    below: 0.5em,
  )[
    #set text(size: 1.15em, weight: "bold")
    #it.body
    #v(-.85em)
    #line(length: 100%, stroke: 0.5pt + accent-color)
  ]

  body
}

// Converts Markdown strings to Typst content.
// Handles arrays recursively and leaves other values unchanged.
#let md(value) = {
  import "@preview/cmarker:0.1.10"

  if type(value) == str {
    cmarker.render(value, raw-typst: false)
  } else if type(value) == array {
    value.map(item => md(item))
  } else {
    value
  }
}

// Formats the title, filters YAML entries,
// and converts selected display fields to Typst content.
#let prep(
  title: "",
  path: "",
  target: "cv",
  markdown-fields: (
    "title",
    "degree",
    "organization",
    "location",
    "dates",
    "details",
    "authors",
    "format",
    "category",
    "skills",
  ),
) = {
  let entries = yaml(path)

  if entries == none or type(entries) != array {
    return none
  }

  let filtered = entries.filter(item => {
    let show-in = item.at("show_in", default: ("cv",))
    show-in.contains(target)
  })

  if filtered.len() == 0 {
    return none
  }

  let converted = filtered.map(item => {
    let result = (:)

    for (key, value) in item {
      result.insert(
        key,
        if markdown-fields.contains(key) {
          md(value)
        } else {
          value
        },
      )
    }

    result
  })

  let title-content = if title != none and title != "" {
    heading(level: 1, title)
  } else {
    []
  }

  return (
    title: title-content,
    entries: converted,
  )
}

// Creates a contact block, with dots between the hyper-linked entries
#let render-contact(
  email: config.at("email", default: ""),
  github: config.at("github", default: ""),
  linkedin: config.at("linkedin", default: ""),
) = {
  let contacts = ()

  if email != "" {
    contacts.push(
      link("mailto:" + email, email)
    )
  }

  if github != "" {
    contacts.push(
      link(
        "https://github.com/" + github,
        "GitHub.com/" + github,
      )
    )
  }

  if linkedin != "" {
    contacts.push(
      link(
        "https://www.linkedin.com/in/" + linkedin,
        "LinkedIn.com/in/" + linkedin,
      )
    )
  }

  if contacts.len() > 0 {
    v(-20pt)

    align(center)[
      #contacts.join(text(fill: luma(55%))[ · ])
    ]
  }
}

// Formats an experience, education, project, or role entry with right-aligned dates
#let exp-entry(
  title: "",
  organization: "",
  degree: "",
  location: "",
  date: "",
  details: (),
  url: none,
) = {
  grid(
    columns: (1fr, auto),
    align: (left, right),
    gutter: 0pt,
    [
      #strong(title)
      #if degree != "" [— #strong(degree)]
    ],
    [
      #if date != "" [
        #text(fill: luma(60))[#date]
      ]
    ]
  )
  if organization != "" or location != "" {
    v(-4pt)
    text(fill: accent-color)[
      #if organization != "" [#organization]
      #if organization != "" and location != "" [ · ]
      #if location != "" [#text(fill: luma(80))[#location]]
    ]
  }
  if details != () and details.len() > 0 {
    v(-3pt)
    list(..details.map(d => [#md(d)]))
  }
  v(1.5pt)
}

// Render Experience entries with target filtering (resume vs cv)
#let render-experiences(
  title: "",
  path: "",
  target: "cv",
) = {
  let prepared = prep(
    title: title,
    path: path,
    target: target,
  )

  if prepared == none {
    return
  }

  prepared.title

  for item in prepared.entries {
    exp-entry(
      title: item.title,
      organization: item.at("organization", default: ""),
      degree: item.at("degree", default: ""),
      location: item.at("location", default: ""),
      date: item.at("dates", default: ""),
      details: item.at("details", default: ()),
      url: item.at("link", default: none),
    )
  }
}

// Render Research entries with target filtering (resume vs cv)
#let render-research(
  title: "",
  path: "",
  target: "cv",
) = {
  let prepared = prep(
    title: title,
    path: path,
    target: target,
  )

  if prepared == none {
    return
  }

  prepared.title

  for item in prepared.entries {
    [
      - #md(item.authors + " (" + item.dates + "). " + item.title + ". " + item.format + ", " + item.location + ".")
    ]
  }
}

// Render Skills entries with target filtering (resume vs cv)
#let render-skills(
  title: "",
  path: "",
  target: "cv",
) = {
  let prepared = prep(
    title: title,
    path: path,
    target: target,
  )

  if prepared == none {
    return
  }

  prepared.title

  set par(justify: false)

  grid(
    columns: (auto, 1fr),
    column-gutter: 0.9em,
    row-gutter: 0.8em,
    align: (left, left),

  ..prepared.entries.map(item => {
    let skills = if type(item.skills) == array {
    item.skills.join(", ")
  } else {
    item.skills
  }

  (
    strong(item.category + ":"),
    skills,
  )
}).flatten(),
  )
}

// Render Awards
#let render-awards(
  title: "",
  path: "",
  target: "cv",
) = {
  let prepared = prep(
    title: title,
    path: path,
    target: target,
  )

  if prepared == none {
    return
  }

  prepared.title

  for item in prepared.entries {
    grid(
      columns: (1fr, auto),
      align: (left, right),
      gutter: 0pt,
      [
        - #strong(item.name), #item.organization
      ],
      [
        #text(fill: luma(60))[#item.dates]
      ]
    )
  }
}

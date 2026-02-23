#import "@preview/tufted:0.1.0"
#import "mathyml/src/lib.typ" as mathyml
#import mathyml: to-mathml
#import mathyml.prelude: *

#let toc-mode = state("toc-mode", false)

#let template(
  title: "Tufted",
  content
) = {
  show: tufted.template-refs
  show: tufted.template-notes
  show: tufted.template-figures
  show math.equation: inner => {
    if inner.block {
      html.p(to-mathml(inner))
    } else {
      to-mathml(inner)
    }
  }

  let css = (
    "https://cdnjs.cloudflare.com/ajax/libs/tufte-css/1.8.0/tufte.min.css",
    "/assets/tufted.css",
    "/assets/custom.css",
  )

  html.html(
    lang: "en",
    {
      // Head
      html.head({
        html.meta(charset: "utf-8")
        html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
        html.title(title)

        // Stylesheets
        for (css-link) in css {
          html.link(rel: "stylesheet", href: css-link)
        }

        mathyml.stylesheets()
      })

      // Body
      html.body({
        // Add website header
        tufted.make-header((
          "/": "Home",
          "/blog/": "Blog",
        ))

        // Main content
        html.article(
          html.section([
            = #title

            #content
          ]),
        )
      })
    },
  )
}

#let post(
  title: "",
  date: datetime.today(),
  content
) = {
  [
    #metadata((
      date: date,
      title: title,
    )) <post-metadata>
  ]

  show: template.with(title: title)

  [
    _#{date.display()}_

    #content
  ]
}

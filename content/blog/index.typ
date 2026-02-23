#import "../../config.typ": template, tufted
#show: template.with(title: "Blog")

#{
  let posts = json("../../index.json").map(post => (
    path: post.path,
    title: post.title,
    date: eval(post.date),
  )).sorted(key: it => it.date).rev()

  let years = (:)
  for post in posts {
    let posts-in-year = years.remove(str(post.date.year()), default: ());
    posts-in-year.push(post);
    years.insert(str(post.date.year()), posts-in-year);
  }

  for (year, posts) in years.pairs() {
    [== #year]
    for post in posts {
      [- #link(post.path, post.title) (_#post.date.display()_)]
    }
  }
}

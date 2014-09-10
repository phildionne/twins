# Twins

Twins sorts through the small differences between multiple objects and smartly consolidate all of them together.

[![Gem Version](https://badge.fury.io/rb/twins.png)](http://badge.fury.io/rb/twins)
[![Code Climate](https://codeclimate.com/github/phildionne/twins.png)](https://codeclimate.com/github/phildionne/twins)
[![Dependency Status](https://gemnasium.com/phildionne/twins.png)](https://gemnasium.com/phildionne/twins)
[![Build Status](https://travis-ci.org/phildionne/twins.png)](https://travis-ci.org/phildionne/twins)
[![twins API Documentation](https://www.omniref.com/ruby/gems/twins.png)](https://www.omniref.com/ruby/gems/twins)

## Usage

Let's say you have a collection of objects representing the same book but from different sources, which brings the possibility for each object to be slightly different from one another.

```ruby
books = [{
  title: "Shantaram: A Novel",
  author: "Gregory David Roberts",
  published: 2012,
  details: {
    paperback: true
  }
},
{
  title: "Shantaram",
  author: "Gregory David Roberts & Alejandro Palomas",
  published: 2012,
  details: {
    paperback: false
  }
},
{
  title: "Shantaram",
  author: "Gregory David Roberts",
  published: 2012,
  details: {
    paperback: true
  }
},
{
  title: "Shantaram",
  author: "Gregory D. Roberts",
  published: 2005,
  details: {
    paperback: true
  }
}]
```

### Consolidate

Assembles a new `Hash` based on every elements in the collection. By default `Twins#consolidate` will determine the candidate values based on the most frequent value present for a given key, also known as the [mode](http://en.wikipedia.org/wiki/Mode_(statistics)).

```ruby
Twins.consolidate(books)
{
  title: "Shantaram",
  author: "Gregory David Roberts",
  published: 2012,
  details: {
    paperback: true
  }
}
```

You may also provide `Twins#consolidate` with priorities for `String` and `Numeric` attributes, which will precede on the mode while determining the canditate value.

```ruby
options = {
  priority: {
    title: "Novel"
  }
}

Twins.consolidate(books, options)
{
  title: "Shantaram: A Novel",
  author: "Gregory David Roberts",
  published: 2012,
  details: {
    paperback: true
  }
}
```

### Pick

Selects the collection's most representative element. By default `Twins.pick` will determine the candidate element based on the highest count of modes present for a given element.

```ruby
Twins.pick(books)
{
  title: "Shantaram",
  author: "Gregory David Roberts",
  published: 2012,
  details: {
    paperback: true
  }
}
```

You may also provide `Twins#pick` with priorities for `String` and `Numeric` attributes, which will be used to compute each element's overall distance while determining the canditate element.

```ruby
options = {
  priority: {
    title: "Novel"
  }
}

Twins.pick(books, options)
{
  title: "Shantaram: A Novel",
  author: "Gregory David Roberts",
  published: 2012,
  details: {
    paperback: true
  }
}
```

## Internals

### Distance

[String distances](https://github.com/phildionne/twins/blob/master/lib/twins/utilities.rb#L19) are calculated using a [longest subsequence algorithm](http://en.wikipedia.org/wiki/Longest_common_subsequence_problem) and [Numeric distances](https://github.com/phildionne/twin/blob/master/lib/twin/utilities.rb#L40) are calculated with their difference.


# Contributing

1. Fork it
2. [Create a topic branch](http://learn.github.com/p/branching.html)
3. Add specs for your unimplemented modifications
4. Run `bundle exec rspec`. If specs pass, return to step 3.
5. Implement your modifications
6. Run `bundle exec rspec`. If specs fail, return to step 5.
7. Commit your changes and push
8. [Submit a pull request](http://help.github.com/send-pull-requests/)
9. Thank you!

# TODO

- Think about using [jaccard](https://github.com/francois/jaccard) to weight items

# Author

[Philippe Dionne](http://phildionne.com)

# License

See [LICENSE](https://github.com/phildionne/twins/blob/master/LICENSE)

# Twin

Twin sorts through the small differences between multiple objects and smartly consolidate all of them together.

[![Gem Version](https://badge.fury.io/rb/twins.png)](http://badge.fury.io/rb/twins)
[![Code Climate](https://codeclimate.com/github/phildionne/twins.png)](https://codeclimate.com/github/phildionne/twins)
[![Coverage Status](https://coveralls.io/repos/phildionne/twins/badge.png)](https://coveralls.io/r/phildionne/twins)
[![Dependency Status](https://gemnasium.com/phildionne/twins.png)](https://gemnasium.com/phildionne/twins)
[![Build Status](https://travis-ci.org/phildionne/twins.png)](https://travis-ci.org/phildionne/twins)

## Usage

By default `Twin` will determine the candidate value based on the most frequent value present for a same key, also known as the [mode](http://en.wikipedia.org/wiki/Mode_(statistics)).

```ruby
books = [{
  title: "Shantaram: A Novel",
  author: "Gregory David Roberts",
  published: 2005,
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

You may also provide `Twin` with priorities for `String` and `Numeric` attributes, which will precede on the mode while determining the canditate value. [String distances](https://github.com/phildionne/twin/blob/master/lib/twin/utilities.rb#L32) are calculated using a [longest subsequence algorithm](http://en.wikipedia.org/wiki/Longest_common_subsequence_problem) and [Numeric distances](https://github.com/phildionne/twin/blob/master/lib/twin/utilities.rb#L40) are calculated with their difference.

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
  published: 2005,
  details: {
    paperback: true
  }
}
```

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

# Author

[Philippe Dionne](http://phildionne.com)

# License

See [LICENSE](https://github.com/phildionne/twins/blob/master/LICENSE)

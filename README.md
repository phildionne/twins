# Twin

[![Gem Version](https://badge.fury.io/rb/twin.png)](http://badge.fury.io/rb/twin)
[![Code Climate](https://codeclimate.com/github/phildionne/twin.png)](https://codeclimate.com/github/phildionne/twin)
[![Coverage Status](https://coveralls.io/repos/phildionne/twin/badge.png)](https://coveralls.io/r/phildionne/twin)
[![Dependency Status](https://gemnasium.com/phildionne/twin.png)](https://gemnasium.com/phildionne/twin)
[![Build Status](https://travis-ci.org/phildionne/twin.png)](https://travis-ci.org/phildionne/twin)

## Usage

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


Twin.consolidate(books)
{
  title: "Shantaram",
  author: "Gregory David Roberts",
  published: 2012,
  details: {
    paperback: true
  }
}
```

You may also provide a priority hash, which will be used to determine the best canditate for consolidation. Strings distance are calculated using a [longest subsequence algorithm](http://en.wikipedia.org/wiki/Longest_common_subsequence_problem) and Numerics distance are calculated from their difference.

```ruby
options = {
  priority: {
    title: "Novel"
  }
}

Twin.consolidate(books, options)
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

See [LICENSE](https://github.com/phildionne/twin/blob/master/LICENSE)

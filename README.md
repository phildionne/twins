# Twin


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

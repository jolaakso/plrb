# Introduction

This is a rudimentary Prolog DSL for Ruby. The Prolog implementation here is based on the one presented in [Paradigms of AI Programming](https://github.com/norvig/paip-lisp/blob/main/docs/chapter11.md) by Peter Norvig.

# Example usage

As per Prolog convention, logic variables are symbols that start with a capital letter.

```ruby
require './db.rb'

db = DB.new

db.define do |p|
    p.mom_of(:alice, :carol)
    p.dad_of(:bob, :carol)
    p.mom_of(:alice, :david)
    p.dad_of(:bob, :david)
    p.mom_of(:eve, :grace)
    p.dad_of(:frank, :grace)
    
    p.older_than(:carol, :david)
    
    p.parent_of(:X, :Y) <= [p.mom_of(:X, :Y)]
    p.parent_of(:X, :Y) <= [p.dad_of(:X, :Y)]
    
    p.sibling_of(:X, :Y) <= [p.parent_of(:Z, :Y), p.parent_of(:Z, :X)]
end

# Query the older child of alice as X and the younger child as Y
db.query do |q|
    q.mom_of(:alice, :X)
    q.sibling_of(:X, :Y)
    q.older_than(:X, :Y)
end

# => Returns an Enumerator that enumerates the solutions
#    [{:X=>:carol, :Y=>:david}, {:X=>:carol, :Y=>:david}]
```

The above example some features of the implementation, but highlights also some currently missing features.

Features:
* Native-like DSL
* Query returns an `Enumerator`, results are calculated one-by-one on demand, rather than all at once in a batch

Missing features:
* Cut operator (duplicate solutions could be fixed with this)
* Primitives
* In fact, any pre-defined predicates
* Unit tests
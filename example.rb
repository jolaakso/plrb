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
result = db.query do |q|
    q.mom_of(:alice, :X)
    q.sibling_of(:X, :Y)
    q.older_than(:X, :Y)
end

print(result.to_a)
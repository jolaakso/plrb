require './db.rb'



db = DB.new

#db.add_clause!(Clause.new(Relation.new(:likes, [:kissa, :hotaru])))
#db.add_clause!(Clause.new(Relation.new(:likes, [:koira, :kissa])))
#db.add_clause!(Clause.new(Relation.new(:likes, [:orava, :kissa])))
#db.add_clause!(Clause.new(Relation.new(:likes, [:hotaru, :X]), [Relation.new(:likes, [:X, :kissa])]))

db.define do |p|
    p.likes(:kissa, :hotaru)
    p.likes(:koira, :kissa)
    p.likes(:orava, :kissa)
    p.likes(:hotaru, :X) <= [p.likes(:X, :kissa)]
end
#print(db.inspect)
print(db.query { |q| q.likes(:hotaru, :Y) }.to_a)

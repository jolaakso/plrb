require './clause_adder.rb'
require './bindings.rb'
require './helpers.rb'

class DB
    def initialize
        @predicates = {}
    end

    def define(&block)
        adder = ClauseAdder.new
        block.yield(adder)
        adder.commit_to_db!(self)
    end

    def query(&block)
        adder = ClauseAdder.new
        block.yield(adder)
        adder.query(self)
    end

    def add_clause!(clause)
        name = clause.head.name
        existing_clause = @predicates[name]
        if existing_clause.is_a?(Array)
            existing_clause.push(clause)
        else
            @predicates[name] = [clause]
        end
    end

    def prove(goal, bindings, other_goals, modifier)
        @predicates[goal.name].each do |pred|
            renamed_pred = pred.renamed
            # print("#{bindings.dict}, #{renamed_pred.head.args}, #{goal.args}, #{bindings.unify(renamed_pred.head.args, goal.args)}   ")
            result = prove_all_goals(renamed_pred.body + other_goals, bindings.unify(renamed_pred.head.args, goal.args), modifier)
            modifier.call(result) if result != nil
        end
        nil
    end

    def prove_all_goals(goals, bindings, modifier)
        return nil if bindings.nil?
        return bindings if goals.empty?
        first_goal, *rest = goals
        prove(first_goal, bindings, rest, modifier)
    end

    def prove_all(goals, modifier = nil)
        Enumerator.new do |yielder|
            if !modifier
                vars = Helpers.find_variables(goals)
                modifier = Proc.new { |binding| yielder << vars.zip(binding.substitute(vars)).to_h }
            end

            prove_all_goals(goals, Bindings.new, modifier)
        end 
    end
end
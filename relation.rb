require './helpers'

class Relation
    def initialize(name, args)
        raise "Predicate name #{name} must be symbol, got #{name.class}" if !name.is_a?(Symbol)
        raise "Predicate name must not be a logic variable, got #{name}" if Helpers.is_variable?(name)
        @name = name
        @args = args
    end

    def name
        @name
    end

    def args
        @args
    end

    def variables
        Helpers.find_variables(args)
    end

    def renamed(vars_dict = {})
        Relation.new(name, Helpers.substitute_vars(@args, vars_dict))
    end
end
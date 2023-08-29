require './helpers'

class Bindings
    def initialize(dict = {})
        @bindings = dict
    end

    def dict
        @bindings
    end

    def occupied?
        !dict.empty?
    end

    def lookup(name)
        @bindings[name]
    end

    def extend!(name, value)
        @bindings[name] = value
    end

    def match_name!(name, value)
        binding = lookup(name)
        
        if !binding
            extend(name, value)
        elsif value != binding
            return nil
        end

        self
    end

    def copy
        Bindings.new(dict.clone)
    end

    def unify(x, y)
        copy.unify!(x, y)
    end

    def unify!(x, y)
        if x == y 
            self
        elsif Helpers.is_variable?(x)
            unify_name!(x, y)
        elsif Helpers.is_variable?(y)  
            unify_name!(y, x)
        elsif x.is_a?(Array) && y.is_a?(Array)
            return self if x.empty? && y.empty?
            head_x, *tail_x = x
            head_y, *tail_y = y
            return nil if unify!(head_x, head_y) == nil
            return nil if unify!(tail_x, tail_y) == nil
            self
        else
            nil
        end
    end

    def unify_name!(name, value)
        bound_name = lookup(name)
        if bound_name
            unify!(bound_name, value)
        elsif Helpers.is_variable?(value) && !!(bound_value = lookup(value))
            unify!(name, bound_value)
        else
            extend!(name, value)
            self
        end
    end

    def substitute(expr)
        if Helpers.is_variable?(expr) && (bound_value = lookup(expr))
            substitute(bound_value)
        elsif !expr.is_a?(Array)
            expr
        else
            expr.map do |subexpr|
                substitute(subexpr)
            end
        end
    end
end
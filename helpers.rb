module Helpers
    def Helpers.is_variable?(sym)
        sym.class == Symbol && !!/[[:upper:]]/.match(sym.to_s[0])
    end
    
    def Helpers.random_symbol(sym)
        "#{sym.to_s}#{Random.new.rand(1..999999).to_s}".to_sym
    end
    
    def Helpers.find_variables(x)
        if is_variable?(x)
            [x]
        elsif x.is_a?(Array)
            x.map { |term| find_variables(term) }.flatten.uniq
        elsif x.is_a?(Relation)
            x.variables
        else
            []
        end
    end
    
    def Helpers.renamed_variables(vars)
        rename_map = {}
        vars.each do |var|
            rename_map[var] = random_symbol(var)
        end
        
        rename_map
    end
    
    def Helpers.substitute_vars(x, rename_map = nil)
        if !rename_map
            rename_map = renamed_variables(find_variables(x))
        end
        
        if x.is_a?(Array)
            x.map { |term| substitute_vars(term, rename_map) }
        elsif (var = rename_map[x])
            var
        else
            x
        end
    end
end
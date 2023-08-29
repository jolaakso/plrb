require './helpers'

class Clause
    def initialize(head, body = [])
        raise "Body must be an array, got #{body}" if !body.is_a?(Array)
        @head = head
        @body = body
    end

    def head
        @head
    end

    def body
        @body
    end

    def name
        head.name
    end

    def renamed
        renamed_vars = Helpers.renamed_variables(Helpers.find_variables([head.args, body.map(&:args)]))
        #print(renamed_vars)
        Clause.new(head.renamed(renamed_vars), body.map{ |rel| rel.renamed(renamed_vars) })
    end
end
require './clause.rb'
require './relation.rb'

class ClauseAdder
    class PredicateWrapper
        def initialize(name, args)
            arg_count = args.length
            raise "Predicate needs to have at least one variable" if arg_count < 1
            @name = "#{name.to_s}/#{arg_count.to_s}".to_sym
            @args = args
            @body = []
            @bodyof = nil
        end

        def args
            @args
        end

        def name
            @name
        end

        def bodyof
            @bodyof
        end

        def bodyof=(bodyof)
            @bodyof = bodyof
        end

        def <=(body_preds)
            body_preds.each do |body_pred|
                body_pred.bodyof = self
            end

            @body = body_preds
        end

        def relation
            Relation.new(name, args)
        end

        def clause
            Clause.new(relation, @body.map(&:relation))
        end
    end

    def initialize
        @commit = []
    end

    def commit_to_db!(db)
        @commit.each do |pred|
            if !pred.bodyof
                db.add_clause!(pred.clause)
            end
        end
        @commit = []
    end

    def query(db)
        queries = @commit.map(&:relation)
        @commit = []
        db.prove_all(queries)
    end

    def method_missing(name, *args, &_)
        wrapped = PredicateWrapper.new(name, args)
        @commit << wrapped
        wrapped
    end
end
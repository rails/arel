module Arel
  module Expressions
    def count distinct = false
      Nodes::Count.new [self], distinct
    end

    def sum
      Nodes::Sum.new [self], Nodes::SqlLiteral.new(build_alias_name('sum'))
    end

    def maximum
      Nodes::Max.new [self], Nodes::SqlLiteral.new(build_alias_name('max'))
    end

    def minimum
      Nodes::Min.new [self], Nodes::SqlLiteral.new(build_alias_name('min'))
    end

    def average
      Nodes::Avg.new [self], Nodes::SqlLiteral.new(build_alias_name('avg'))
    end
    
    private
    
      def build_alias_name(kind)
        [kind, self.name] * '_'
      end
  end
end

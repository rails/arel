module Arel
  class DeleteManager < Arel::TreeManager
    def initialize engine
      super
      @ast = Nodes::DeleteStatement.new
      @ctx = @ast
    end

    def from relation
      @ast.relation = relation
      self
    end

    def take limit
      @ast.limit = Nodes::Limit.new(limit) if limit
      self
    end

    def wheres= list
      @ast.wheres = list
    end
  end
end

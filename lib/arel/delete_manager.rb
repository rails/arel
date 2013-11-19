require 'arel/lock_manager'

module Arel
  class DeleteManager < Arel::TreeManager
    include Arel::LockManager

    def initialize engine
      super
      @ast = Nodes::DeleteStatement.new
      @ctx = @ast
    end

    def from relation
      @ast.relation = relation
      self
    end

    def wheres= list
      @ast.wheres = list
    end
  end
end

module Arel
  module LockManager
    def lock locking = Arel.sql('FOR UPDATE')
      case locking
      when true
        locking = Arel.sql('FOR UPDATE')
      when Arel::Nodes::SqlLiteral
      when String
        locking = Arel.sql locking
      end

      @ast.lock = Nodes::Lock.new(locking)
      self
    end

    def locked
      @ast.lock
    end
  end
end

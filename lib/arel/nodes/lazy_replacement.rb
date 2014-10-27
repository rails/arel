module Arel
  module Nodes
    class LazyReplacement < Arel::Nodes::Node
      def initialize(&block)
        @block = block
      end

      def execute(value)
        @block.call(value)
      end

      def to_s
        raise ArgumentError.new("All `LazyReplacement`s must be substituted for a real value")
      end
    end
  end
end

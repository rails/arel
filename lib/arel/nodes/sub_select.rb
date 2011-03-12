module Arel
  module Nodes
    class SubSelect < Arel::Nodes::Node
      attr_accessor :select, :as

      def initialize(select, as = nil)
        @select = select
        @as = as || 'subquery'
      end
    end
  end
end
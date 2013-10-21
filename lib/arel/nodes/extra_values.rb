module Arel
  module Nodes
    class ExtraValues < Arel::Nodes::Node
      attr_accessor :values

      def initialize values
        @values = values.is_a?(Array) ? values : [values]
        super()
      end
    end
  end
end

module Arel
  module Nodes
    class Ordering < Unary
      REVERSE_NULLS = { first: :last, last: :first }

      attr_accessor :nulls

      def initialize(expr, options = {})
        super(expr)
        @nulls = options[:nulls]
      end

      def hash
        [@expr, @nulls].hash
      end

      def eql?(other)
        super && self.nulls == other.nulls
      end

      protected
        def reverse_nulls
          REVERSE_NULLS.fetch(nulls, nil)
        end
    end
  end
end

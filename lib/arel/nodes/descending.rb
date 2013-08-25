module Arel
  module Nodes
    class Descending < Ordering

      def reverse
        Ascending.new(expr, nulls: reverse_nulls)
      end

      def direction
        :desc
      end

      def ascending?
        false
      end

      def descending?
        true
      end

    end
  end
end

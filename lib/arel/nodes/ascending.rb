module Arel
  module Nodes
    class Ascending < Ordering

      def reverse
        Descending.new(expr, nulls: reverse_nulls)
      end

      def direction
        :asc
      end

      def ascending?
        true
      end

      def descending?
        false
      end

    end
  end
end

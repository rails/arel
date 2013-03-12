module Arel
  module Visitors
    class PostgreSQL < Arel::Visitors::ToSql
      alias :visit_Bignum :quoted
      alias :visit_Fixnum :quoted

      private

      def visit_Arel_Nodes_Matches o
        "#{visit o.left} ILIKE #{visit o.right}"
      end

      def visit_Arel_Nodes_DoesNotMatch o
        "#{visit o.left} NOT ILIKE #{visit o.right}"
      end

      def visit_Arel_Nodes_DistinctOn o
        "DISTINCT ON ( #{visit o.expr} )"
      end
    end
  end
end

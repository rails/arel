module Arel
  module Visitors
    class PostgreSQL < Arel::Visitors::ToSql
      private

      def visit_Arel_Nodes_Matches o, a
        "#{visit o.left, a} ILIKE #{visit o.right, a}"
      end

      def visit_Arel_Nodes_DoesNotMatch o, a
        "#{visit o.left, a} NOT ILIKE #{visit o.right, a}"
      end

      def visit_Arel_Nodes_DistinctOn o, a
        "DISTINCT ON ( #{visit o.expr, a} )"
      end

      def visit_Array o, a
        columns = a.relation.engine.connection.columns a.relation.name
        column = columns.find { |col| col.name.to_s == a.name.to_s }

        if column && column.array
          quoted o, a
        else
          super
        end
      end
    end
  end
end

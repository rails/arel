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

      def visit_Arel_Nodes_As o, a
        "#{visit o.left, a} AS #{o.right}"
      end

      def visit_Arel_Nodes_TableAlias o, a
        "#{visit o.relation, a} #{o.name}"
      end

      def visit_Arel_Nodes_NamedFunction o, a
        "#{o.name}(#{o.distinct ? 'DISTINCT ' : ''}#{o.expressions.map { |x|
          visit x, a
        }.join(', ')})#{o.alias ? " AS #{o.alias}" : ''}"
      end

      def visit_Arel_Nodes_Extract o, a
        "EXTRACT(#{o.field.to_s.upcase} FROM #{visit o.expr, a})#{o.alias ? " AS #{o.alias}" : ''}"
      end

      def visit_Arel_Nodes_Count o, a
        "COUNT(#{o.distinct ? 'DISTINCT ' : ''}#{o.expressions.map { |x|
          visit x, a
        }.join(', ')})#{o.alias ? " AS #{o.alias}" : ''}"
      end

      def visit_Arel_Nodes_Sum o, a
        "SUM(#{o.distinct ? 'DISTINCT ' : ''}#{o.expressions.map { |x|
          visit x, a }.join(', ')})#{o.alias ? " AS #{o.alias}" : ''}"
      end

      def visit_Arel_Nodes_Exists o, a
        "EXISTS (#{visit o.expressions, a})#{
          o.alias ? " AS #{o.alias}" : ''}"
      end

      def visit_Arel_Nodes_Max o, a
        "MAX(#{o.distinct ? 'DISTINCT ' : ''}#{o.expressions.map { |x|
          visit x, a }.join(', ')})#{o.alias ? " AS #{o.alias}" : ''}"
      end

      def visit_Arel_Nodes_Min o, a
        "MIN(#{o.distinct ? 'DISTINCT ' : ''}#{o.expressions.map { |x|
          visit x, a }.join(', ')})#{o.alias ? " AS #{o.alias}" : ''}"
      end

      def visit_Arel_Nodes_Avg o, a
        "AVG(#{o.distinct ? 'DISTINCT ' : ''}#{o.expressions.map { |x|
          visit x, a }.join(', ')})#{o.alias ? " AS #{o.alias}" : ''}"
      end
    end
  end
end

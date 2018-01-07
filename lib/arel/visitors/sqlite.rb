# frozen_string_literal: true
module Arel
  module Visitors
    class SQLite < Arel::Visitors::ToSql
      private

      def visit_Arel_Nodes_Union o, collector
        join_str = o.operation ? " UNION #{o.operation.to_s.upcase} " : " UNION "
        inject_join(o.children, collector, join_str)
      end

      # INTERSECT ALL is not supported in SQLite
      def visit_Arel_Nodes_Intersect o, collector
        inject_join(o.children, collector, " INTERSECT ")
      end

      # EXCEPT ALL is not supported in SQLite
      def visit_Arel_Nodes_Except o, collector
        inject_join(o.children, collector, " EXCEPT ")
      end

      # Locks are not supported in SQLite
      def visit_Arel_Nodes_Lock o, collector
        collector
      end

      def visit_Arel_Nodes_SelectStatement o, collector
        o.limit = Arel::Nodes::Limit.new(-1) if o.offset && !o.limit
        super
      end

      def visit_Arel_Nodes_True o, collector
        collector << "1"
      end

      def visit_Arel_Nodes_False o, collector
        collector << "0"
      end

    end
  end
end

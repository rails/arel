module Arel
  module Visitors
    class PostgreSQL < Arel::Visitors::ToSql
      private

      def visit_Arel_Nodes_Matches o, collector
        collector = infix_value o, collector, ' ILIKE '
        if o.escape
          collector << ' ESCAPE '
          visit o.escape, collector
        else
          collector
        end
      end

      def visit_Arel_Nodes_DoesNotMatch o, collector
        collector = infix_value o, collector, ' NOT ILIKE '
        if o.escape
          collector << ' ESCAPE '
          visit o.escape, collector
        else
          collector
        end
      end

      def visit_Arel_Nodes_Regexp o, collector
        infix_value o, collector, ' ~ '
      end

      def visit_Arel_Nodes_NotRegexp o, collector
        infix_value o, collector, ' !~ '
      end

      def visit_Arel_Nodes_DistinctOn o, collector
        collector << "DISTINCT ON ( "
        visit(o.expr, collector) << " )"
      end

      def visit_Arel_Nodes_BindParam o, collector
        collector.add_bind(o) { |i| "$#{i}" }
      end

      def visit_Arel_Nodes_DeleteStatement o, collector
        return super if !o.relation.is_a?(Arel::Nodes::JoinSource) || o.relation.right.empty?

        collector << "DELETE FROM "
        collector = visit o.relation.left, collector

        collector << " USING "
        collector = inject_join o.relation.right, collector, ", "

        unless o.wheres.empty?
          collector << " WHERE "
          collector = inject_join o.wheres, collector, " AND "
        end

        collector
      end

      def visit_Arel_Nodes_UpdateStatement o, collector
        return super if !o.relation.is_a?(Arel::Nodes::JoinSource) || o.relation.right.empty?

        collector << "UPDATE "
        collector = visit o.relation.left, collector

        unless o.values.empty?
          collector << " SET "
          collector = inject_join o.values, collector, ", "
        end

        collector << " FROM "
        collector = inject_join o.relation.right, collector, ", "

        unless o.wheres.empty?
          collector << " WHERE "
          collector = inject_join o.wheres, collector, " AND "
        end

        collector
      end
    end
  end
end

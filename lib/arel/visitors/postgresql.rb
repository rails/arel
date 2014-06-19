module Arel
  module Visitors
    class PostgreSQL < Arel::Visitors::ToSql
      private

      def visit_Arel_Nodes_Matches o, collector
        infix_value o, collector, ' ILIKE '
      end

      def visit_Arel_Nodes_DoesNotMatch o, collector
        infix_value o, collector, ' NOT ILIKE '
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

      def visit_Arel_Nodes_UpdateStatement o, collector
        if o.orders.empty? && o.limit.nil?
          wheres = o.wheres
        else
          wheres = [Nodes::In.new(o.key, [build_subselect(o.key, o)])]
        end

        collector << "UPDATE "

        if o.relation.right && o.relation.right.first.instance_of?(Arel::Nodes::InnerJoin) && o.cores.first.source.empty?
          o.cores = o.relation
          collector = visit o.relation.left, collector
        else
          collector = visit o.relation, collector
        end

        unless o.values.empty?
          collector << " SET "
          collector = inject_join o.values, collector, ", "
        end

        unless o.cores.empty? && o.cores.right.empty?
          collector << " FROM "
          collector = visit o.cores.right.first.left, collector
        end

        unless wheres.empty?
          collector << " WHERE "
          collector = inject_join wheres, collector, " AND "
        end

        collector
      end
    end
  end
end

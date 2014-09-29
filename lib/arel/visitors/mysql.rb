module Arel
  module Visitors
    class MySQL < Arel::Visitors::ToSql
      private
      # Custom visitor that recursively implements paren-squashing behavior for unions
      def visit_union(child, collector)
        case child
        when Arel::Nodes::Union
          visit_Arel_Nodes_Union child, collector, true
        else
          visit child, collector
        end
      end

      # Copy of ToSql#inject_join using the custom paren-squashing visitor for unions
      def union_inject_join list, collector
        len = list.length - 1
        list.each_with_index.inject(collector) { |c, (x,i)|
          if i == len
            visit_union x, c
          else
            visit_union(x, c) << ' UNION '
          end
        }
      end

      def visit_Arel_Nodes_Union o, collector, suppress_parens = false
        unless suppress_parens
          collector << "( "
        end

        union_inject_join(o.children, collector)

        if suppress_parens
          collector
        else
          collector << " )"
        end
      end

      def visit_Arel_Nodes_Bin o, collector
        collector << "BINARY "
        visit o.expr, collector
      end

      ###
      # :'(
      # http://dev.mysql.com/doc/refman/5.0/en/select.html#id3482214
      def visit_Arel_Nodes_SelectStatement o, collector
        if o.offset && !o.limit
          o.limit = Arel::Nodes::Limit.new(18446744073709551615)
        end
        super
      end

      def visit_Arel_Nodes_SelectCore o, collector
        o.froms ||= Arel.sql('DUAL')
        super
      end

      def visit_Arel_Nodes_UpdateStatement o, collector
        collector << "UPDATE "
        collector = visit o.relation, collector

        unless o.values.empty?
          collector << " SET "
          collector = inject_join o.values, collector, ', '
        end

        unless o.wheres.empty?
          collector << " WHERE "
          collector = inject_join o.wheres, collector, ' AND '
        end

        unless o.orders.empty?
          collector << " ORDER BY "
          collector = inject_join o.orders, collector, ', '
        end

        maybe_visit o.limit, collector
      end

    end
  end
end

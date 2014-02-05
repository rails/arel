module Arel
  module Visitors
    class Informix < Arel::Visitors::ToSql
      private
      def visit_Arel_Nodes_SelectStatement o, a
        [
          SELECT,
          (visit(o.offset, a) if o.offset),
          (visit(o.limit, a) if o.limit),
          o.cores.map { |x| visit_Arel_Nodes_SelectCore x, a }.join,
          ("ORDER BY #{o.orders.map { |x| visit x, a }.join(COMMA_)}" unless o.orders.empty?),
          (visit(o.lock, a) if o.lock),
        ].compact.join SPACE
      end
      def visit_Arel_Nodes_SelectCore o, a
        [
          "#{o.projections.map { |x| visit x, a }.join COMMA_}",
          ("FROM #{visit(o.source, a)}" if o.source && !o.source.empty?),
          ("WHERE #{o.wheres.map { |x| visit x, a }.join AND}" unless o.wheres.empty?),
          ("GROUP BY #{o.groups.map { |x| visit x, a }.join COMMA_}" unless o.groups.empty?),
          (visit(o.having, a) if o.having),
        ].compact.join SPACE
      end
      def visit_Arel_Nodes_Offset o, a
        "SKIP #{visit o.expr, a}"
      end
      def visit_Arel_Nodes_Limit o, a
        "LIMIT #{visit o.expr, a}"
      end
    end
  end
end


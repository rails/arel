module Arel
  module Visitors
    class Firebird < Arel::Visitors::ToSql
    protected

      def visit_Arel_Nodes_SelectStatement o, *a
        select_core = o.cores.map { |x| visit_Arel_Nodes_SelectCore(x, *a) }.join
        select_core.sub!(/^\s*SELECT/i, "SELECT #{visit(o.offset)}") if o.offset && !o.limit
        [
          select_core,
          ("ORDER BY #{o.orders.map { |x| visit(x) }.join(', ')}" unless o.orders.empty?),
          (limit_offset(o) if o.limit && o.offset),
          (visit(o.limit) if o.limit && !o.offset),
        ].compact.join ' '
      end

      def visit_Arel_Nodes_UpdateStatement o, *a
        [
          "UPDATE #{visit o.relation}",
          ("SET #{o.values.map { |value| visit(value) }.join ', '}" unless o.values.empty?),
          ("WHERE #{o.wheres.map { |x| visit(x) }.join ' AND '}" unless o.wheres.empty?),
          (visit(o.limit) if o.limit),
        ].compact.join ' '
      end

      def visit_Arel_Nodes_Limit o, *a
        "ROWS #{visit(o.expr)}"
      end

      def visit_Arel_Nodes_Offset o, *a
        "SKIP #{visit(o.expr)}"
      end

    private
      def limit_offset(o)
        "ROWS #{visit(o.offset.expr) + 1} TO #{visit(o.offset.expr) + visit(o.limit.expr)}"
      end
    end
  end
end

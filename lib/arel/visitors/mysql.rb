module Arel
  module Visitors
    class MySQL < Arel::Visitors::ToSql
      private
      def visit_Arel_Nodes_Lock o
        visit o.expr
      end

      ###
      # :'(
      # http://dev.mysql.com/doc/refman/5.0/en/select.html#id3482214
      def visit_Arel_Nodes_SelectStatement o
        o.limit = Arel::Nodes::Limit.new(18446744073709551615) if o.offset && !o.limit
        super
      end

      def visit_Arel_Nodes_SelectCore o
        o.froms ||= Arel.sql('DUAL')
        super
      end

      def visit_Arel_Nodes_UpdateStatement o
        [
          "UPDATE #{visit o.relation}",
          ("SET #{o.values.map { |value| visit value }.join ', '}" unless o.values.empty?),
          ("WHERE #{o.wheres.map { |x| visit x }.join ' AND '}" unless o.wheres.empty?),
          ("ORDER BY #{o.orders.map { |x| visit x }.join(', ')}" unless o.orders.empty?),
          (visit(o.limit) if o.limit),
        ].compact.join ' '
      end

      # Force MySQL to always do a case sensitive search on equality
      def visit_Arel_Nodes_Equality o
        right = o.right

        if right.nil?
          "#{visit o.left} IS NULL"
        else
          "#{visit o.left} = BINARY #{visit right}"
        end
      end

      # Force MySQL to always do a case sensitive search on inequality
      def visit_Arel_Nodes_NotEqual o
        right = o.right

        if right.nil?
          "#{visit o.left} IS NOT NULL"
        else
          "#{visit o.left} != BINARY #{visit right}"
        end
      end
    end
  end
end

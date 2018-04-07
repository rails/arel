# frozen_string_literal: true
module Arel
  module Visitors
    module OracleInCondition
      def self.in_condition_limit
        1000
      end

      def visit_Arel_Nodes_In o, collector
        if Array === o.right && o.right.empty?
          collector << '1=0'
        else
          collector << "("
          first_slice = true
          o.right.each_slice(OracleInCondition.in_condition_limit) do |slice|
            if first_slice
              first_slice = false
            else
              collector << " OR "
            end
            collector = visit o.left, collector
            collector << " IN ("
            collector = visit slice, collector
            collector << ")"
          end
          collector << ")"
        end
      end

      def visit_Arel_Nodes_NotIn o, collector
        if Array === o.right && o.right.empty?
          collector << '1=1'
        else
          collector << "("
          first_slice = true
          o.right.each_slice(OracleInCondition.in_condition_limit) do |slice|
            if first_slice
              first_slice = false
            else
              collector << " AND "
            end
            collector = visit o.left, collector
            collector << " NOT IN ("
            collector = visit slice, collector
            collector << ")"
          end
          collector << ")"
        end
      end
    end
  end
end


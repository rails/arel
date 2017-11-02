# frozen_string_literal: true

require 'forwardable'

module Arel
  module Nodes
    class SqlLiteral
      include Arel::Expressions
      include Arel::Predications
      include Arel::AliasPredication
      include Arel::OrderPredications
      extend Forwardable

      def_delegators :@string,
                     :===, :==, :to_str, :to_s, :gsub, :inspect, :hash

      def eql?(val)
        self == val
      end

      def initialize(string)
        @string = string
      end
    end
  end
end

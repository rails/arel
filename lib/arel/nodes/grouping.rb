# frozen_string_literal: true
module Arel
  module Nodes
    class Grouping < Unary
      include Arel::Expressions
      include Arel::Predications
      include Arel::AliasPredication
      include Arel::OrderPredications
      include Arel::Math
    end
  end
end

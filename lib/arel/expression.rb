module Arel
  module Expression
    include Arel::OrderPredications

    def concat other
      Nodes::Concatenation.new self, other
    end

  end
end

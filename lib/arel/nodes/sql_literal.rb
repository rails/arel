module Arel
  module Nodes
    class SqlLiteral < String
      include Arel::Expressions
      include Arel::Predications
      include Arel::AliasPredication
      include Arel::OrderPredications
       
      def encode_with(coder)
        coder['string'] = self.to_s
      end
      
      def init_with(coder)
        self << coder['string']
      end
    end

    class BindParam < SqlLiteral
    end
  end
end

module Arel
  module Nodes
    class DeleteStatement < Arel::Nodes::Node
      attr_accessor :relation, :wheres, :orders, :limit
      attr_accessor :key

      def initialize relation = nil, wheres = []
        @relation = relation
        @wheres   = wheres
        @orders   = []
        @limit    = nil
        @key = nil
      end

      def initialize_copy other
        super
        @wheres = @wheres.clone
      end

      def hash
        [@relation, @wheres, @orders, @limit, @key].hash
      end

      def eql? other
        self.class == other.class &&
            self.relation == other.relation &&
            self.wheres == other.wheres &&
            self.orders == other.orders &&
            self.limit == other.limit &&
            self.key == other.key
      end
      alias :== :eql?
    end
  end
end

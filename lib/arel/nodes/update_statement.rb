module Arel
  module Nodes
    class UpdateStatement < Arel::Nodes::Node
      attr_accessor :cores
      attr_accessor :relation, :wheres, :values, :orders, :limit
      attr_accessor :key

      def initialize cores = [SelectCore.new]
        @cores    = cores
        @relation = nil
        @wheres   = []
        @values   = []
        @orders   = []
        @limit    = nil
        @key      = nil
      end

      def initialize_copy other
        super
        @cores  = @cores.map { |x| x.clone }
        @wheres = @wheres.clone
        @values = @values.clone
      end

      def hash
        [@cores, @relation, @wheres, @values, @orders, @limit, @key].hash
      end

      def eql? other
        self.class == other.class &&
          self.cores == other.cores &&
          self.relation == other.relation &&
          self.wheres == other.wheres &&
          self.values == other.values &&
          self.orders == other.orders &&
          self.limit == other.limit &&
          self.key == other.key
      end
      alias :== :eql?
    end
  end
end

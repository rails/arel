module Arel
  module Nodes
    class DeleteStatement < Arel::Nodes::Node
      attr_accessor :relation, :source, :wheres

      def initialize
        @relation = nil
        @source   = nil
        @wheres   = []
      end

      def initialize_copy other
        super
        @relation = @relation.clone if @relation
        @source   = @source.clone   if @source
        @wheres   = @wheres.clone   if @wheres
      end

      def hash
        [@relation, @source, @wheres].hash
      end

      def eql? other
        self.class == other.class &&
          self.relation == other.relation &&
          self.source   == other.source   &&
          self.wheres   == other.wheres
      end
      alias :== :eql?

    end
  end
end

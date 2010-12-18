module Arel
  module Nodes
    class SelectCore < Arel::Nodes::Node
      attr_accessor :projections, :wheres, :groups, :withs
      attr_accessor :having, :source

      def initialize
        @source      = JoinSource.new nil
        @withs       = []
        @projections = []
        @wheres      = []
        @groups      = []
        @having      = nil
      end

      def from
        @source.left
      end

      def from= value
        @source.left = value
      end

      alias :froms= :from=
      alias :froms :from

      def initialize_copy other
        super
        @source      = @source.clone if @source
        @projections = @projections.clone
        @wheres      = @wheres.clone
        @group       = @groups.clone
        @having      = @having.clone if @having
      end
    end
  end
end

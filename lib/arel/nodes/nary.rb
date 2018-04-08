# frozen_string_literal: true
module Arel
  module Nodes
    class Nary < Arel::Nodes::Node
      attr_reader :children

      def initialize children
        super()
        @children = children
      end

      def initialize_copy other
        super
        @children = @children.map { |child| child.clone }
      end

      def hash
        children.hash
      end

      def eql? other
        self.class == other.class &&
          self.children == other.children
      end
      alias :== :eql?
    end

    %w{
      And
      Or
    }.each do |name|
      const_set name, Class.new(Nary)
    end
  end
end

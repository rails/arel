# frozen_string_literal: true
module Arel
  module Nodes
    class SetOperation < Nary
      attr_reader :operation

      def initialize(children, operation = nil)
        super(children)
        @operation = operation
      end
    end

    %w{
      Union
      Intersect
      Except
    }.each do |name|
      const_set name, Class.new(SetOperation)
    end
  end
end

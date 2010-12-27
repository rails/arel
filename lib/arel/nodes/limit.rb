module Arel
  module Nodes
    class Limit
      attr_accessor :value

      def initialize value
        @value = value
      end
    end
  end
end


require 'helper'

module Arel
  module Nodes
    describe LazyReplacement do
      it "executes the given block with a value" do
        adds_one = LazyReplacement.new { |value| value + 1 }
        subs_one = LazyReplacement.new { |value| value - 1 }

        adds_one.execute(1).must_equal(2)
        subs_one.execute(1).must_equal(0)
      end

      it "cannot be converted to a string" do
        node = LazyReplacement.new

        assert_raises(ArgumentError) do
          node.to_s
        end
      end
    end
  end
end

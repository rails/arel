require 'helper'

module Arel
  module Visitors
    describe 'avoiding contamination between visitor dispatch tables' do
      Collector = Struct.new(:calls) do
        def call object
          calls << object
        end
      end

      before do
        @connection = Table.engine.connection
        @table = Table.new(:users)
      end

      it 'dispatches properly after failing upwards' do
        node = Nodes::Union.new(Nodes::True.new, Nodes::False.new)
        assert_equal "( TRUE UNION FALSE )", node.to_sql

        node.first # from Nodes::Node's Enumerable mixin

        assert_equal "( TRUE UNION FALSE )", node.to_sql
      end

      it "throws a legitimate NoMethodError when cannot fail upwards" do
        @collector = Collector.new []
        @visitor = Visitors::DepthFirst.new @collector
        raises_exception = lambda { |_| raise NoMethodError.new }

        @visitor.stub :dispatch_method, raises_exception do
          assert_raises NoMethodError do
            @visitor.accept ::Arel::Nodes::Not.new(:a)
          end
        end
      end

    end
  end
end


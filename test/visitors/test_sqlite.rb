# frozen_string_literal: true
require 'helper'

module Arel
  module Visitors
    describe 'the sqlite visitor' do
      before do
        @visitor = SQLite.new Table.engine.connection_pool
      end

      def compile node
        @visitor.accept(node, Collectors::SQLString.new).value
      end

      it 'suppresses parens parenthesis on multiple unions' do
        subnode = Nodes::Union.new [Arel.sql('left'), Arel.sql('right')]
        node    = Nodes::Union.new [subnode, Arel.sql('topright')]
        assert_equal 0, compile(node).scan('(').length

        subnode = Nodes::Union.new [Arel.sql('left'), Arel.sql('right')]
        node    = Nodes::Union.new [Arel.sql('topleft'), subnode]
        assert_equal 0, compile(node).scan('(').length
      end

      it 'defaults limit to -1' do
        stmt = Nodes::SelectStatement.new
        stmt.offset = Nodes::Offset.new(1)
        sql = @visitor.accept(stmt, Collectors::SQLString.new).value
        sql.must_be_like "SELECT LIMIT -1 OFFSET 1"
      end

      it 'does not support locking' do
        node = Nodes::Lock.new(Arel.sql('FOR UPDATE'))
        assert_equal '', @visitor.accept(node, Collectors::SQLString.new).value
      end

      it 'does not support boolean' do
        node = Nodes::True.new()
        assert_equal '1', @visitor.accept(node, Collectors::SQLString.new).value
        node = Nodes::False.new()
        assert_equal '0', @visitor.accept(node, Collectors::SQLString.new).value
      end
    end
  end
end

require 'helper'

module Arel
  module Visitors
    describe 'the mysql visitor' do
      before do
        @visitor = MySQL.new Table.engine.connection
      end

      def compile node
        @visitor.accept(node, Collectors::SQLString.new).value
      end

      it 'squashes parenthesis on multiple unions' do
        subnode = Nodes::Union.new Arel.sql('left'), Arel.sql('right')
        node    = Nodes::Union.new subnode, Arel.sql('topright')
        assert_equal 1, compile(node).scan('(').length

        subnode = Nodes::Union.new Arel.sql('left'), Arel.sql('right')
        node    = Nodes::Union.new Arel.sql('topleft'), subnode
        assert_equal 1, compile(node).scan('(').length
      end

      ###
      # :'(
      # http://dev.mysql.com/doc/refman/5.0/en/select.html#id3482214
      it 'defaults limit to 18446744073709551615' do
        stmt = Nodes::SelectStatement.new
        stmt.offset = Nodes::Offset.new(1)
        sql = compile(stmt)
        sql.must_be_like "SELECT FROM DUAL LIMIT 18446744073709551615 OFFSET 1"
      end

      it "should escape LIMIT" do
        sc = Arel::Nodes::UpdateStatement.new
        sc.relation = Table.new(:users)
        sc.limit = Nodes::Limit.new(Nodes.build_quoted("omg"))
        assert_equal("UPDATE \"users\" LIMIT 'omg'", compile(sc))
      end

      it 'uses DUAL for empty from' do
        stmt = Nodes::SelectStatement.new
        sql = compile(stmt)
        sql.must_be_like "SELECT FROM DUAL"
      end

      describe 'locking' do
        it 'defaults to FOR UPDATE when locking' do
          node = Nodes::Lock.new(Arel.sql('FOR UPDATE'))
          compile(node).must_be_like "FOR UPDATE"
        end

        it 'allows a custom string to be used as a lock' do
          node = Nodes::Lock.new(Arel.sql('LOCK IN SHARE MODE'))
          compile(node).must_be_like "LOCK IN SHARE MODE"
        end
      end

      describe 'deleting' do
        it 'adds join sources if present to USING clause' do
          stmt = Nodes::DeleteStatement.new
          stmt.relation = Table.new(:users)
          stmt.source = Nodes::JoinSource.new stmt.relation
          stmt.source.right << Nodes::StringJoin.new('foo');
          sql = @visitor.accept(stmt)
          sql.must_be_like %{ DELETE FROM "users" USING "users" 'foo' }
        end

        it 'does not include USING clause without join sources' do
          stmt = Nodes::DeleteStatement.new
          stmt.relation = Table.new(:users)
          stmt.source = Nodes::JoinSource.new stmt.relation
          sql = @visitor.accept(stmt)
          sql.must_be_like %{ DELETE FROM "users" }
        end
      end

    end
  end
end

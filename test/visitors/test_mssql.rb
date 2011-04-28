require 'helper'

module Arel
  module Visitors
    describe 'the mssql visitor' do
      before do
        @visitor = MSSQL.new Table.engine
      end

      it 'uses TOP to limit results' do
        stmt = Nodes::SelectStatement.new
        stmt.cores.last.top = Nodes::Top.new(1)
        sql = @visitor.accept(stmt)
        sql.must_be_like "SELECT TOP 1"
      end

      describe 'updates with a limit' do
        before do
          @stmt = Nodes::UpdateStatement.new
          @stmt.limit = Nodes::Limit.new(1)
          @stmt.key = 'id'
        end

        it 'uses TOP in updates with a limit' do
          sql = @visitor.accept(@stmt)
          sql.must_be_like "UPDATE NULL WHERE 'id' IN (SELECT TOP 1 'id' )"
        end

        it 'passes where clauses into the subselect' do
          @stmt.wheres << :x
          sql = @visitor.accept(@stmt)
          sql.must_be_like "UPDATE NULL WHERE 'id' IN (SELECT TOP 1 'id' WHERE 'x' )"
        end
      end
    end
  end
end

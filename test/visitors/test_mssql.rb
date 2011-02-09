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

      describe 'updates' do
        before do
          @stmt = Nodes::UpdateStatement.new
        end

        describe 'with a limit' do
          before do
            @stmt.limit = Nodes::Limit.new(1)
          end

          it 'uses TOP in updates with a limit' do
            @stmt.key = 'id'
            sql = @visitor.accept(@stmt)
            sql.must_be_like "UPDATE NULL WHERE 'id' IN (SELECT TOP 1 'id' )"
          end

          it 'passes where clauses into the subselect' do
            @stmt.key = 'id'
            @stmt.wheres << :x
            sql = @visitor.accept(@stmt)
            sql.must_be_like "UPDATE NULL WHERE 'id' IN (SELECT TOP 1 'id' WHERE 'x' )"
          end
        end
      end

    end
  end
end

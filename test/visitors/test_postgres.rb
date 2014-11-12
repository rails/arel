require 'helper'

module Arel
  module Visitors
    describe 'the postgres visitor' do
      before do
        @visitor = PostgreSQL.new Table.engine.connection
        @table = Table.new(:users)
        @attr = @table[:id]
      end

      def compile node
        @visitor.accept(node, Collectors::SQLString.new).value
      end

      describe 'locking' do
        it 'defaults to FOR UPDATE' do
          compile(Nodes::Lock.new(Arel.sql('FOR UPDATE'))).must_be_like %{
            FOR UPDATE
          }
        end

        it 'allows a custom string to be used as a lock' do
          node = Nodes::Lock.new(Arel.sql('FOR SHARE'))
          compile(node).must_be_like %{
            FOR SHARE
          }
        end
      end

      it "should escape LIMIT" do
        sc = Arel::Nodes::SelectStatement.new
        sc.limit = Nodes::Limit.new(Nodes.build_quoted("omg"))
        sc.cores.first.projections << Arel.sql('DISTINCT ON')
        sc.orders << Arel.sql("xyz")
        sql =  compile(sc)
        assert_match(/LIMIT 'omg'/, sql)
        assert_equal 1, sql.scan(/LIMIT/).length, 'should have one limit'
      end

      it 'should support DISTINCT ON' do
        core = Arel::Nodes::SelectCore.new
        core.set_quantifier = Arel::Nodes::DistinctOn.new(Arel.sql('aaron'))
        assert_match 'DISTINCT ON ( aaron )', compile(core)
      end

      it 'should support DISTINCT' do
        core = Arel::Nodes::SelectCore.new
        core.set_quantifier = Arel::Nodes::Distinct.new
        assert_equal 'SELECT DISTINCT', compile(core)
      end
    
      it 'generates an update statement with a FROM instead of join' do
        posts = Table.new(:posts)
        relation = Arel::Nodes::JoinSource.new(
          @table,
          [@table.create_join(posts)]
        )
        stmt = Arel::Nodes::UpdateStatement.new
        stmt.relation = relation

        stmt.values << @table[:name].eq(posts[:title])
        stmt.wheres << posts[:user_id].eq(@table[:id])

        assert_equal("UPDATE \"users\" SET \"users\".\"name\" = \"posts\".\"title\" FROM \"posts\" WHERE \"posts\".\"user_id\" = \"users\".\"id\"", compile(stmt))
      end

      it 'should have a valid UpdateManager with FROM instead of JOINS' do
        normal_visitor = Table.engine.connection.visitor
        # set postgresql as visitor to test
        Table.engine.connection.visitor = @visitor

        um = Arel::UpdateManager.new Table.engine
        join_source = Arel::Nodes::JoinSource.new(
          @table,
          [@table.create_join(Table.new(:posts))]
        )

        um.table join_source
        um.to_sql.must_be_like %{ UPDATE "users" FROM "posts" }
        # revert back to_sql as visitor
        Table.engine.connection.visitor = normal_visitor
      end

      describe "Nodes::Matches" do
        it "should know how to visit" do
          node = @table[:name].matches('foo%')
          compile(node).must_be_like %{
            "users"."name" ILIKE 'foo%'
          }
        end

        it 'can handle subqueries' do
          subquery = @table.project(:id).where(@table[:name].matches('foo%'))
          node = @attr.in subquery
          compile(node).must_be_like %{
            "users"."id" IN (SELECT id FROM "users" WHERE "users"."name" ILIKE 'foo%')
          }
        end
      end

      describe "Nodes::DoesNotMatch" do
        it "should know how to visit" do
          node = @table[:name].does_not_match('foo%')
          compile(node).must_be_like %{
            "users"."name" NOT ILIKE 'foo%'
          }
        end

        it 'can handle subqueries' do
          subquery = @table.project(:id).where(@table[:name].does_not_match('foo%'))
          node = @attr.in subquery
          compile(node).must_be_like %{
            "users"."id" IN (SELECT id FROM "users" WHERE "users"."name" NOT ILIKE 'foo%')
          }
        end
      end

      describe "Nodes::Regexp" do
        it "should know how to visit" do
          node = Arel::Nodes::Regexp.new(@table[:name], Nodes.build_quoted('foo%'))
          compile(node).must_be_like %{
            "users"."name" ~ 'foo%'
          }
        end

        it 'can handle subqueries' do
          subquery = @table.project(:id).where(Arel::Nodes::Regexp.new(@table[:name], Nodes.build_quoted('foo%')))
          node = @attr.in subquery
          compile(node).must_be_like %{
            "users"."id" IN (SELECT id FROM "users" WHERE "users"."name" ~ 'foo%')
          }
        end
      end

      describe "Nodes::NotRegexp" do
        it "should know how to visit" do
          node = Arel::Nodes::NotRegexp.new(@table[:name], Nodes.build_quoted('foo%'))
          compile(node).must_be_like %{
            "users"."name" !~ 'foo%'
          }
        end

        it 'can handle subqueries' do
          subquery = @table.project(:id).where(Arel::Nodes::NotRegexp.new(@table[:name], Nodes.build_quoted('foo%')))
          node = @attr.in subquery
          compile(node).must_be_like %{
            "users"."id" IN (SELECT id FROM "users" WHERE "users"."name" !~ 'foo%')
          }
        end
      end
    end
  end
end

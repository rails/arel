# frozen_string_literal: true
require 'helper'

module Arel
  module Visitors
    describe 'the oracle12 visitor' do
      before do
        @visitor = Oracle12.new Table.engine.connection
        @table = Table.new(:users)
      end

      def compile node
        @visitor.accept(node, Collectors::SQLString.new).value
      end

      it 'modified except to be minus' do
        left = Nodes::SqlLiteral.new("SELECT * FROM users WHERE age > 10")
        right = Nodes::SqlLiteral.new("SELECT * FROM users WHERE age > 20")
        sql = compile Nodes::Except.new(left, right)
        sql.must_be_like %{
          ( SELECT * FROM users WHERE age > 10 MINUS SELECT * FROM users WHERE age > 20 )
        }
      end

      it 'generates select options offset then limit' do
        stmt = Nodes::SelectStatement.new
        stmt.offset = Nodes::Offset.new(1)
        stmt.limit = Nodes::Limit.new(10)
        sql = compile(stmt)
        sql.must_be_like "SELECT OFFSET 1 ROWS FETCH FIRST 10 ROWS ONLY"
      end

      describe 'locking' do
        it 'generates ArgumentError if limit and lock are used' do
          stmt = Nodes::SelectStatement.new
          stmt.limit = Nodes::Limit.new(10)
          stmt.lock = Nodes::Lock.new(Arel.sql('FOR UPDATE'))
          assert_raises ArgumentError do
            compile(stmt)
          end
        end

        it 'defaults to FOR UPDATE when locking' do
          node = Nodes::Lock.new(Arel.sql('FOR UPDATE'))
          compile(node).must_be_like "FOR UPDATE"
        end
      end

      describe "Nodes::BindParam" do
        it "increments each bind param" do
          query = @table[:name].eq(Arel::Nodes::BindParam.new(1))
            .and(@table[:id].eq(Arel::Nodes::BindParam.new(1)))
          compile(query).must_be_like %{
            "users"."name" = :a1 AND "users"."id" = :a2
          }
        end
      end

      describe "maxiumum in condition length" do
        it "splits IN clause values into Arel::Visitors::OracleInCondition.in_condition_limit sized chunks" do
          Arel::Visitors::OracleInCondition.stub :in_condition_limit, 5 do
            node = @table[:id].in([1, 2, 3, 4, 5, 6, 7, 8])
            compile(node).must_be_like %{
              ("users"."id" IN (1, 2, 3, 4, 5) OR "users"."id" IN (6, 7, 8))
            }
          end
        end

        it "splits NOT IN condition values into Arel::Visitors::Oracle.in_clause_length sized chunks" do
          Arel::Visitors::OracleInCondition.stub :in_condition_limit, 5 do
            node = @table[:id].not_in([1, 2, 3, 4, 5, 6, 7, 8])
            compile(node).must_be_like %{
              ("users"."id" NOT IN (1, 2, 3, 4, 5) AND "users"."id" NOT IN (6, 7, 8))
            }
          end
        end
      end
    end
  end
end

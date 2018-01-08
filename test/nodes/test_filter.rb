# frozen_string_literal: true
require 'helper'

describe Arel::Nodes::Filter do
  it 'should add filter to expression' do
    table = Arel::Table.new :users
    table[:id].count.filter(table[:gdp_per_capita].gteq(40_000)).to_sql.must_be_like %{
        COUNT("users"."id") FILTER (WHERE "users"."gdp_per_capita" >= 40000)
      }
  end

  describe 'as' do
    it 'should alias the expression' do
      table = Arel::Table.new :users
      table[:id].count.filter(table[:gdp_per_capita].gteq(40_000)).as('foo').to_sql.must_be_like %{
        COUNT("users"."id") FILTER (WHERE "users"."gdp_per_capita" >= 40000) AS foo
      }
    end
  end

  describe 'over' do
    it 'should reference the window definition by name' do
      table = Arel::Table.new :users
      window = Arel::Nodes::Window.new.partition(table[:year])
      table[:id].count.filter(table[:gdp_per_capita].gteq(40_000)).over(window).to_sql.must_be_like %{
        COUNT("users"."id") FILTER (WHERE "users"."gdp_per_capita" >= 40000) OVER (PARTITION BY "users"."year")
      }
    end
  end
end

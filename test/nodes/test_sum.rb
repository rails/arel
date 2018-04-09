# frozen_string_literal: true
require 'helper'

describe Arel::Nodes::Sum do
  describe "as" do
    it 'should alias the sum' do
      table = Arel::Table.new :users
      table[:id].sum.as('foo').to_sql.must_be_like %{
        SUM("users"."id") AS foo
      }
    end
  end

  describe 'equality' do
    it 'is equal with equal ivars' do
      array = [Arel::Nodes::Sum.new('foo'), Arel::Nodes::Sum.new('foo')]
      assert_equal 1, array.uniq.size
    end

    it 'is not equal with different ivars' do
      array = [Arel::Nodes::Sum.new('foo'), Arel::Nodes::Sum.new('foo!')]
      assert_equal 2, array.uniq.size
    end
  end

  describe 'order' do
    it 'should order the sum' do
      table = Arel::Table.new :users
      table[:id].sum.desc.to_sql.must_be_like %{
        SUM("users"."id") DESC
      }
    end
  end

  describe 'math' do
    it 'should be able to use math operators' do
      table = Arel::Table.new :users
      (table[:id].sum - 2).to_sql.must_be_like %{
        (SUM("users"."id") - 2)
      }
    end
  end
end

require 'helper'
require 'ostruct'

module Arel
  module Nodes
    describe 'table alias' do
      describe 'equality' do
        it 'is equal with equal ivars' do
          relation1 = Table.new(:users)
          node1     = TableAlias.new relation1, :foo
          relation2 = Table.new(:users)
          node2     = TableAlias.new relation2, :foo
          array = [node1, node2]
          assert_equal 1, array.uniq.size
        end

        it 'is not equal with different ivars' do
          relation1 = Table.new(:users)
          node1     = TableAlias.new relation1, :foo
          relation2 = Table.new(:users)
          node2     = TableAlias.new relation2, :bar
          array = [node1, node2]
          assert_equal 2, array.uniq.size
        end
      end

      describe '#clone' do
        it 'works when using a symbol for the alias' do
          relation = Table.new(:users)
          node     = TableAlias.new relation, :foo
          assert node.clone
        end
      end
    end
  end
end

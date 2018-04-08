# frozen_string_literal: true
require 'helper'

module Arel
  module Nodes
    describe 'or' do
      describe '#or' do
        it 'makes an OR node' do
          attr = Table.new(:users)[:id]
          left  = attr.eq(10)
          right = attr.eq(11)
          node  = left.or right
          node.expr.children[0].must_equal left
          node.expr.children[1].must_equal right

          oror = node.or(right)
          oror.expr.children[0].must_equal node
          oror.expr.children[1].must_equal right
        end
      end

      describe 'equality' do
        it 'is equal with equal ivars' do
          array = [Or.new(['foo', 'bar']), Or.new(['foo', 'bar'])]
          assert_equal 1, array.uniq.size
        end

        it 'is not equal with different ivars' do
          array = [Or.new(['foo', 'bar']), Or.new(['foo', 'baz'])]
          assert_equal 2, array.uniq.size
        end
      end
    end
  end
end

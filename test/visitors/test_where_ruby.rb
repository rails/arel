require 'helper'
#require 'ruby-debug'
module Arel
  module Visitors

    class TestUser
      attr_accessor :id, :name

      def initialize(attr = {})
        attr.each_pair {|k, v| send("#{k}=", v) }
      end
    end

    class TestWhereRuby < MiniTest::Unit::TestCase
      def setup
        @relation = Table.new(:users)
      end

      def test_greater_than_or_equal
        m = @relation.where @relation[:id].gteq(42)
        m.would_include?(TestUser.new(id: 43)).must_equal true
        m.would_include?(TestUser.new(id: 42)).must_equal true
        m.would_include?(TestUser.new(id: 41)).must_equal false
      end

      def test_greater_than
        m = @relation.where @relation[:id].gt(42)
        m.would_include?(TestUser.new(id: 43)).must_equal true
        m.would_include?(TestUser.new(id: 42)).must_equal false
        m.would_include?(TestUser.new(id: 41)).must_equal false
      end

      def test_less_than_or_equal
        m = @relation.where @relation[:id].lteq(42)
        m.would_include?(TestUser.new(id: 43)).must_equal false
        m.would_include?(TestUser.new(id: 42)).must_equal true
        m.would_include?(TestUser.new(id: 41)).must_equal true
      end

      def test_less_than
        m = @relation.where @relation[:id].lt(42)
        m.would_include?(TestUser.new(id: 43)).must_equal false
        m.would_include?(TestUser.new(id: 42)).must_equal false
        m.would_include?(TestUser.new(id: 41)).must_equal true
      end

      def test_matches
        m = @relation.where @relation[:name].matches('%bacon%')
        m.would_include?(TestUser.new(name: 'chunky')).must_equal false
        m.would_include?(TestUser.new(name: 'bacon')).must_equal true
        m.would_include?(TestUser.new(name: 'some bacon now')).must_equal true
      end

      def test_matches_with_escape
        m = @relation.where @relation[:name].matches('%\% bacon%')
        m.would_include?(TestUser.new(name: 'chunky')).must_equal false
        m.would_include?(TestUser.new(name: ' bacon')).must_equal false
        m.would_include?(TestUser.new(name: '100% bacon')).must_equal true
      end

      def test_does_not_match
        m = @relation.where @relation[:name].does_not_match('%bacon%')
        m.would_include?(TestUser.new(name: 'chunky')).must_equal true
        m.would_include?(TestUser.new(name: 'bacon')).must_equal false
        m.would_include?(TestUser.new(name: 'some bacon now')).must_equal false
      end

      # how to test_not?

      def test_in
        m = @relation.where @relation[:id].in([1,2,3])
        m.would_include?(TestUser.new(id: 1)).must_equal true
        m.would_include?(TestUser.new(id: 4)).must_equal false

        m = @relation.where @relation[:id].in([])
        m.would_include?(TestUser.new(id: 1)).must_equal false
      end

      def test_not_in
        m = @relation.where @relation[:id].not_in([1,2,3])
        m.would_include?(TestUser.new(id: 1)).must_equal false
        m.would_include?(TestUser.new(id: 4)).must_equal true

        m = @relation.where @relation[:id].not_in([])
        m.would_include?(TestUser.new(id: 1)).must_equal true
      end

      def test_and
        m = @relation.where @relation[:id].gt_all([42, 77])
        m.would_include?(TestUser.new(id: 41)).must_equal false
        m.would_include?(TestUser.new(id: 43)).must_equal false
        m.would_include?(TestUser.new(id: 78)).must_equal true
      end

      def test_or
        m = @relation.where @relation[:id].gt_any([42, 77])
        m.would_include?(TestUser.new(id: 41)).must_equal false
        m.would_include?(TestUser.new(id: 43)).must_equal true
        m.would_include?(TestUser.new(id: 78)).must_equal true
      end

      def test_equality
        m = @relation.where @relation[:id].eq(42)
        m.would_include?(TestUser.new(id: 42)).must_equal true
        m.would_include?(TestUser.new(id: 43)).must_equal false
        m.would_include?(TestUser.new(id: nil)).must_equal false
      end

      def test_not_equal
        m = @relation.where @relation[:id].not_eq(42)
        m.would_include?(TestUser.new(id: 42)).must_equal false
        m.would_include?(TestUser.new(id: 43)).must_equal true
        m.would_include?(TestUser.new(id: nil)).must_equal true
      end

      # how to test_addition, subtraction, multiplication, division, infix_operation?

      def test_true
        m = @relation.where true
        m.would_include?(TestUser.new).must_equal true
      end

      def test_false
        m = @relation.where false
        m.would_include?(TestUser.new).must_equal false
      end
    end
  end
end

require "helper"
require "arel/collectors/base"
require "arel/nodes/node"
require "arel/nodes/lazy_replacement"

class FakeLazyReplacement < Arel::Nodes::LazyReplacement
  def initialize
    super do |value|
      Arel::Nodes::SqlLiteral.new("Replaced with: #{value}")
    end
  end
end

module Arel
  module Collectors
    describe "Base" do
      it "concatenates its parts when compiling" do
        collector = Base.new

        collector << "foo"
        collector << "bar"

        collector.compile([]).must_equal("foobar")
      end

      it "can replace lazy replacement nodes" do
        collector = Base.new

        collector << "foo"
        collector << FakeLazyReplacement.new
        collector << "bar"
        sql = collector.execute_lazy_replacements(["baz"], Visitors::ToSql.new(nil)).compile([])

        sql.must_equal("fooReplaced with: bazbar")
      end
    end
  end
end

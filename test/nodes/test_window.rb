require 'helper'

module Arel::Nodes
  describe Window do
    describe 'backwards compatibility' do
      it 'must be an expression' do
        Window.new.must_be_kind_of Arel::Expression
      end
    end

    describe "order" do
      it "should generate a single argument" do
        table = Arel::Table.new("users")
        Window.new.order(table[:id]).to_sql.must_be_like %{
            (ORDER BY \"users\".\"id\")
        }
      end

      it "should generate multiple arguments" do
        table = Arel::Table.new("users")
        Window.new.order(table[:id], table[:created_at]).to_sql.must_be_like %{
            (ORDER BY \"users\".\"id\", \"users\".\"created_at\")
        }
      end
    end

    describe "partition" do
      it "should generate a single argument" do
        table = Arel::Table.new("users")
        Window.new.partition(table[:id]).to_sql.must_be_like %{
          (PARTITION BY \"users\".\"id\")
        }
      end

      it "should generate multiple arguments" do
        table = Arel::Table.new("users")
        Window.new.partition(table[:id], table[:created_at]).to_sql.must_be_like %{
          (PARTITION BY \"users\".\"id\", \"users\".\"created_at\")
        }
      end
    end

    describe "partition and order" do
      it "should generate partition before order" do
        table = Arel::Table.new("users")
        Window.new.order(table[:id]).partition(table[:id]).to_sql.must_be_like %{
          (PARTITION BY \"users\".\"id\" ORDER BY \"users\".\"id\")
        }
      end
    end
  end
end

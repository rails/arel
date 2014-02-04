require 'helper'

module Arel
  class FakeCrudder < SelectManager
    class FakeEngine
      attr_reader :calls, :connection_pool, :spec, :config

      def initialize
        @calls = []
        @connection_pool = self
        @spec = self
        @config =  { :adapter => 'sqlite3' }
      end

      def connection; self end

      def method_missing name, *args
        @calls << [name, args]
      end
    end

    include Crud

    attr_reader :engine
    attr_accessor :ctx

    def initialize engine = FakeEngine.new
      super
    end
  end

  describe 'crud' do
    describe 'insert' do
      it 'should call insert on the connection' do
        table = Table.new :users
        fc = FakeCrudder.new
        fc.from table
        im = fc.compile_insert [[table[:id], 'foo']]
        assert_instance_of Arel::InsertManager, im
      end
    end

    describe 'update' do
      it 'should call update on the connection' do
        table = Table.new :users
        fc = FakeCrudder.new
        fc.from table
        stmt = fc.compile_update [[table[:id], 'foo']], Arel::Attributes::Attribute.new(table, 'id')
        assert_instance_of Arel::UpdateManager, stmt
      end
    end

    describe 'delete' do
      it 'should call delete on the connection' do
        table = Table.new :users
        fc = FakeCrudder.new
        fc.from table
        stmt = fc.compile_delete
        assert_instance_of Arel::DeleteManager, stmt
      end
    end

    it 'allows an insert on table without manager' do
      table   = Table.new :users
      stmt = table.compile_insert({table[:id] => 1})

      stmt.to_sql.must_be_like %{
        INSERT INTO "users" ("id") VALUES (1)
      }
    end

    it 'allows an update on table without manager' do
      table   = Table.new :users
      stmt = table.compile_update({table[:id] => 1}, Arel::Attributes::Attribute.new(table, 'id'))

      stmt.to_sql.must_be_like %{
        UPDATE "users" SET "id" = 1
      }
    end

    it 'allows a delete on table without manager' do
      table   = Table.new :users
      stmt = table.compile_delete

      stmt.to_sql.must_be_like %{
        DELETE FROM "users"
      }
    end
  end
end

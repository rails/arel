# frozen_string_literal: true
require 'helper'

module Arel
  describe TemporaryTable do
    describe 'new' do
      it 'sets the data_source' do
        rel = TemporaryTable.new 'SELECT * FROM clients', as: 'users'
        rel.data_source.must_equal 'SELECT * FROM clients'
      end

      it 'sets the name with the as attribute' do
        rel = TemporaryTable.new 'SELECT * FROM clients', as: 'users'
        rel.name.must_equal 'users'
      end

      it 'does not set any alias' do
        rel = TemporaryTable.new 'SELECT * FROM clients', as: 'users'
        rel.table_alias.must_be_nil
      end
    end
  end
end

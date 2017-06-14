# frozen_string_literal: true
require 'helper'

module Arel
  describe Subquery do
    describe 'new' do
      it 'sets the data_source' do
        rel = Subquery.new 'SELECT * FROM clients', as: 'users'
        rel.data_source.must_equal 'SELECT * FROM clients'
      end

      it 'sets the name with the as attribute' do
        rel = Subquery.new 'SELECT * FROM clients', as: 'users'
        rel.name.must_equal 'users'
      end

      it 'sets the name with a 10-length random name' do
        rel = Subquery.new 'SELECT * FROM clients'
        rel.name.must_match(/[a-z]{10}/)
      end

      it 'does not set any alias' do
        rel = Subquery.new 'SELECT * FROM clients', as: 'users'
        rel.table_alias.must_be_nil
      end
    end
  end
end

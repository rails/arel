require 'helper'

describe Arel::Nodes::DeleteStatement do
  describe "#clone" do
    it "clones wheres" do
      statement = Arel::Nodes::DeleteStatement.new
      statement.wheres = %w[a b c]

      dolly = statement.clone
      dolly.wheres.must_equal statement.wheres
      dolly.wheres.wont_be_same_as statement.wheres
    end

    it "clones source" do
      statement = Arel::Nodes::DeleteStatement.new
      statement.source = %w[a b c]

      dolly = statement.clone
      dolly.source.must_equal statement.source
      dolly.source.wont_be_same_as statement.source
    end
  end

  describe 'equality' do
    it 'is equal with equal ivars' do
      statement1 = Arel::Nodes::DeleteStatement.new
      statement1.wheres = %w[a b c]
      statement1.source = %w[d e f]
      statement2 = Arel::Nodes::DeleteStatement.new
      statement2.wheres = %w[a b c]
      statement2.source = %w[d e f]
      array = [statement1, statement2]
      assert_equal 1, array.uniq.size
    end

    it 'is not equal with different ivars' do
      statement1 = Arel::Nodes::DeleteStatement.new
      statement1.wheres = %w[a b c]
      statement1.source = %w[d e f]
      statement2 = Arel::Nodes::DeleteStatement.new
      statement2.wheres = %w[1 2 3]
      statement2.source = %w[4 5 6]
      array = [statement1, statement2]
      assert_equal 2, array.uniq.size
    end
  end
end

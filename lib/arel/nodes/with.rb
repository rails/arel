module Arel
  module Nodes
    class With < Arel::Nodes::Binary
      alias :name :left
      alias :relation :right
    end
  end
end

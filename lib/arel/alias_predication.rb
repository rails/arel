module Arel
  module AliasPredication
    def as other
      Nodes::As.new self, other
    end
  end
end

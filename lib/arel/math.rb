module Arel
  module Math
    def *(other)
      Arel::Nodes::Multiplication.new(self, other)
    end

    def +(other)
      Arel::Nodes::Grouping.new(Arel::Nodes::Addition.new(self, other))
    end

    def -(other)
      Arel::Nodes::Grouping.new(Arel::Nodes::Subtraction.new(self, other))
    end

    def /(other)
      Arel::Nodes::Division.new(self, other)
    end

    def &(other)
      Arel::Nodes::BitwiseAnd.new(self, other)
    end

    def |(other)
      Arel::Nodes::BitwiseOr.new(self, other)
    end

    def ^(other)
      Arel::Nodes::BitwiseXor.new(self, other)
    end

    def <<(other)
      Arel::Nodes::BitwiseShiftLeft.new(self, other)
    end

    def >>(other)
      Arel::Nodes::BitwiseShiftRight.new(self, other)
    end

  end
end

module Arel
  module OrderPredications

    def asc(*args)
      Nodes::Ascending.new self, *args
    end

    def desc(*args)
      Nodes::Descending.new self, *args
    end

  end
end

# encoding: utf-8
module Arel
  module Collectors
    class SQLString < PlainString
      def add_bind(bind)
        super(bind.to_s)
      end
    end
  end
end

module Arel
  module Collectors
    class Bind < Base
      def compile(bvs, parts = self.parts)
        super(bvs, substitute_binds(bvs, parts))
      end

      private

      def substitute_binds(bvs, parts)
        bvs = bvs.dup
        parts.map do |val|
          if Arel::Nodes::BindParam === val
            bvs.shift
          else
            val
          end
        end
      end
    end
  end
end

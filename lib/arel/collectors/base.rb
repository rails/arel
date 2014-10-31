module Arel
  module Collectors
    class Base
      def initialize(parts = [])
        @parts = parts
      end

      def <<(other)
        parts << other
        self
      end

      def add_bind(bind)
        parts << bind
        self
      end

      def value
        parts.join
      end

      def compile(bvs, parts = self.parts)
        parts.join
      end

      def execute_lazy_replacements(replacements, visitor)
        replacements = replacements.dup
        collector = with_parts([])

        parts.each do |val|
          if Arel::Nodes::LazyReplacement === val
            ast = val.execute(replacements.shift)
            visitor.accept(ast, collector)
          else
            collector << val
          end
        end

        collector
      end

      protected

      attr_reader :parts

      private

      def with_parts(new_parts)
        self.class.new(new_parts)
      end
    end
  end
end

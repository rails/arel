module Arel
  module Visitors
    class Visitor
      def accept object
        visit object
      end

      private

      DISPATCH = Hash.new do |hash, klass|
        hash[klass] = "visit_#{(klass.name || '').gsub('::', '_')}"
      end

      def dispatch
        DISPATCH
      end

      def visit object, attribute = nil
        object.class.ancestors.each do |klass|
          name = dispatch[klass]
          return send(name, object, attribute) if respond_to?(name, true)
        end
        raise(TypeError, "Cannot visit #{object.class}")
      end
    end
  end
end

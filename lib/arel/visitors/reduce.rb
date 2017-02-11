require 'arel/visitors/visitor'

module Arel
  module Visitors
    class Reduce < Arel::Visitors::Visitor

      def accept object, collector
        visit object, collector
      end

      private

      def dispatch_method(object, collector)
        send dispatch[object.class], object, collector
      end

      def visit object, collector
        dispatch_method(object, collector)
      rescue NoMethodError => e
        superklass = object.class.ancestors.find { |klass|
          respond_to?(dispatch[klass], true)
        }
        raise(TypeError, "Cannot visit #{object.class}") unless superklass
        dispatch[object.class] = dispatch[superklass]
        dispatch_method(object, collector)
      end
    end
  end
end

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
        send dispatch[object.class], object, attribute
      rescue NoMethodError => e
        raise e if respond_to?(dispatch[object.class], true)

        object.class.ancestors.each do |klass|
          name = dispatch[klass]
          if respond_to?(name, true)
            dispatch[object.class] = name
            return send(name, object, attribute)
          end
        end

        raise(TypeError, "Cannot visit #{object.class}")
      end
    end
  end
end

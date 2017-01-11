module Arel
  module Visitors
    class Visitor
      NO_METHOD_MUTEX = ::Mutex.new

      def initialize
        @dispatch = get_dispatch_cache
      end

      def accept object
        visit object
      end

      private

      def self.dispatch_cache
        Hash.new do |hash, klass|
          hash[klass] = "visit_#{(klass.name || '').gsub('::', '_')}"
        end
      end

      def get_dispatch_cache
        self.class.dispatch_cache
      end

      def dispatch
        @dispatch
      end

      def visit object
        send dispatch[object.class], object
      rescue NoMethodError => e
        superklass = object.class.ancestors.find { |klass|
          respond_to?(dispatch[klass], true)
        }

        raise(TypeError, "Cannot visit #{object.class}") unless superklass

        NO_METHOD_MUTEX.synchronize do
          dispatch[object.class] = dispatch[superklass] unless respond_to?(dispatch[object.class], true)
        end

        if respond_to?(dispatch[object.class], true)
          begin
            send dispatch[object.class], object
          rescue NoMethodError => e2
            raise e2
          end
        else
          raise e
        end
      end
    end
  end
end

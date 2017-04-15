# frozen_string_literal: true
module Arel
  module Visitors
    class Visitor
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

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

      def dispatch_method(object)
        send dispatch[object.class], object
      end

      def visit object
        dispatch_method(object)
      rescue NoMethodError => e
        superklass = object.class.ancestors.find { |klass|
          respond_to?(dispatch[klass], true)
        }
        raise(TypeError, "Cannot visit #{object.class}") unless superklass
        dispatch[object.class] = dispatch[superklass]
        dispatch_method(object)
      end
    end
  end
end

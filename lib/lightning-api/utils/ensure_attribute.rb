module LightningApi
  module Utils
    module EnsureAttribute
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def ensure_attribute(klass, attribute_name)
          klass.attr_reader attribute_name unless klass.method_defined?(attribute_name)
        end
      end
    end
  end
end

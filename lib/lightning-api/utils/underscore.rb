module LightningApi
  module Utils
    module Underscore
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def underscore(camel_cased_word)
          return camel_cased_word.to_s unless /[A-Z-]|::/.match?(camel_cased_word)

          word = camel_cased_word.to_s.gsub('::', '/')
          word.gsub!(/([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) do
            (::Regexp.last_match(1) || ::Regexp.last_match(2)) << '_'
          end
          word.tr!('-', '_')
          word.downcase!
          word
        end
      end
    end
  end
end

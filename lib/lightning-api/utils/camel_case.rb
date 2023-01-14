module LightningApi
  module Utils
    module CamelCase
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def camel_case(snake_case_word)
          snake_case_string = snake_case_word.to_s
          return snake_case_string if snake_case_string.empty?

          if snake_case_string.to_s.index('_')
            snake_case_string.to_s.split('_').map(&:capitalize).join
          else
            snake_case_string[0] = snake_case_string[0].upcase
            snake_case_string
          end
        end
      end
    end
  end
end

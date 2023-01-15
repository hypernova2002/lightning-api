module LightningApi
  module Middleware
    class DefaultContentType
      def initialize(app, content_type = 'application/json')
        @app = app
        @content_type = content_type
      end

      def call(env)
        env['CONTENT_TYPE'] = @content_type if invalid_content_type?

        @app.call(env)
      end

      private

      def invalid_content_type?
        env['CONTENT_TYPE'].nil? ||
          env['CONTENT_TYPE'].empty? ||
          env['CONTENT_TYPE'] == 'application/x-www-form-urlencoded'
      end
    end
  end
end

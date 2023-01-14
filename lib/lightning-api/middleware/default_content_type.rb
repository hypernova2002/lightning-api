module LightningApi
  module Middleware
    class DefaultContentType
      def initialize(app, content_type = 'application/json')
        @app = app
        @content_type = content_type
      end

      def call(env)
        if env['CONTENT_TYPE'].nil? || env['CONTENT_TYPE'].empty? || env['CONTENT_TYPE'] == 'application/x-www-form-urlencoded'
          env['CONTENT_TYPE'] = @content_type
        end

        @app.call(env)
      end
    end
  end
end

require 'hanami/api'
require "hanami/middleware/body_parser"

require 'alba'
Alba.backend = :oj

module LightningApi
  class App < Hanami::API
    def self.inherited(base)
      base.autoload
      base.instance_variable_set("@router", self.router)
    end

    def self.autoloader
      @autoloader ||= Zeitwerk::Loader.new
    end

    def self.autoload
      return unless self.name

      namespace = Object.const_get(self.name.split('::')[0])
      autoloader.tag = namespace.to_s.downcase
      autoloader.push_dir(File.join(Dir.getwd, 'app'), namespace:)
      autoloader.push_dir(File.join(Dir.getwd, 'db'), namespace:)
      autoloader.push_dir(File.join(Dir.getwd, 'config'), namespace:)
      autoloader.setup
    end

    use LightningApi::Middleware::DefaultContentType, 'application/json'
    use Hanami::Middleware::BodyParser, :json
    use Rack::ShowExceptions
    use Rack::Deflater
    use Rack::ContentType, 'application/json'
    use Rack::ETag
    use Rack::CommonLogger
  end
end

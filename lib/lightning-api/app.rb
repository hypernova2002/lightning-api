require 'hanami/api'
require 'hanami/middleware/body_parser'

require 'alba'
Alba.backend = :oj

module LightningApi
  class App < Hanami::API
    def self.inherited(base)
      base.autoload
      base.instance_variable_set('@router', router)
      super
    end

    def self.autoloader
      @autoloader ||= Zeitwerk::Loader.new
    end

    def self.autoload
      return unless name

      autoloader.tag = namespace.to_s.downcase
      autoloader.push_dir(expand_filename('app'), namespace:)
      autoloader.push_dir(expand_filename('db'), namespace:)
      autoloader.push_dir(expand_filename('config'), namespace:)
      autoloader.setup
    end

    def self.expand_filename(filename)
      File.join(Dir.getwd, filename)
    end

    def self.namespace
      @namespace ||= Object.const_get(name.split('::')[0])
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

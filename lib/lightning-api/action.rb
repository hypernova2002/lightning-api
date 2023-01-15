module LightningApi
  class Action
    include Pipeline

    attr_reader :dataset, :request, :params, :headers

    pipeline :datasets, :resolvers, :services, :resources

    def self.inherited(action_class)
      action_class.extend(ClassMethods)
      super
    end

    def halt(status, body = nil)
      throw :halt, [status, @headers, [body].compact]
    end

    def call(env)
      @request = rack_request(env)
      @dataset = nil
      @params = request.env['router.params'] || request.params
      @headers = {}

      catch :halt do
        run_pipeline

        [200, @headers, [dataset].compact]
      end
    end

    def rack_request(env)
      Rack::Request.new(env)
    end

    module ClassMethods
      def call(env)
        new.call(env)
      end
    end
  end
end

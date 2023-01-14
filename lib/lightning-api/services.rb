module LightningApi
  module Services
    include Utils::EnsureAttribute

    def self.included(base)
      base.extend(ClassMethods)

      ensure_attribute(base, :user)
      ensure_attribute(base, :dataset)
      ensure_attribute(base, :params)
    end

    def call_services
      return unless service

      @dataset = service.new(user:, dataset:).call(params:)
    end

    def service
      self.class.service_class
    end

    module ClassMethods
      attr_reader :service_class

      def service(service_class)
        @service_class = service_class
      end
    end
  end
end

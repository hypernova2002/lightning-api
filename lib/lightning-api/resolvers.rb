module LightningApi
  module Resolvers
    include Utils::EnsureAttribute

    def self.included(base)
      base.extend(ClassMethods)

      ensure_attribute(base, :user)
      ensure_attribute(base, :dataset)
      # ensure_attribute(base, :request)
      ensure_attribute(base, :params)
    end

    def call_resolvers
      resolver_chain.each do |resolver|
        @dataset = resolver.new(user:, dataset:).resolve(params:)

        halt 404 unless @dataset
      end
    end

    def resolver_chain
      self.class.resolver_chain || []
    end

    module ClassMethods
      attr_reader :resolver_chain

      def resolvers(*resolver_chain)
        @resolver_chain = resolver_chain
      end
    end
  end
end

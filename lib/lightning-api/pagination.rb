require 'pagy'
require 'pagy/extras/headers'

module LightningApi
  module Pagination
    include Utils::EnsureAttribute
    include Pagy::Backend

    def self.included(base)
      ensure_attribute(base, :dataset)
      ensure_attribute(base, :request)
      ensure_attribute(base, :params)
      ensure_attribute(base, :headers)
    end

    def call_pagination
      @pagy, @dataset = pagy(dataset)

      pagy_headers_merge(@pagy)
    end

    private

      def pagy_headers_merge(pagy)
        @headers ||= {}
        headers.merge!(pagy_headers(pagy))
      end

      def pagy_get_vars(collection, vars)
        {
          count: collection.count,
          page: vars[:page] || params[:page] || Pagy::DEFAULT[:page],
          items: vars[:items] || params[:items]  || Pagy::DEFAULT[:items]
        }
      end
  end
end

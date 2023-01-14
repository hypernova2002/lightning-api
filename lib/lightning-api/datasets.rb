module LightningApi
  module Datasets
    include Utils::EnsureAttribute

    def self.included(base)
      base.extend(ClassMethods)

      ensure_attribute(base, :dataset)
    end

    def call_datasets
      @dataset = self.class.dataset if self.class.dataset
    end

    module ClassMethods
      attr_reader :dataset

      def default_dataset(dataset)
        @dataset = dataset
      end
    end
  end
end

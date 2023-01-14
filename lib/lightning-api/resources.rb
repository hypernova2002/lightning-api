module LightningApi
  module Resources
    include Utils::EnsureAttribute

    def self.included(base)
      base.extend(ClassMethods)

      ensure_attribute(base, :user)
      ensure_attribute(base, :dataset)
    end

    def call_resources
      return unless dataset

      @dataset =
        if resource
           resource.new(dataset, params: { user: }).serialize
        else
          inline_serialize(dataset)
        end
    end

    def resource
      self.class.resource_class
    end

    private

      def inline_serialize(dataset)
        data = dataset.respond_to?(:all) ? dataset.all : dataset
        entry = data.is_a?(Array) ? data.first : data

        attribute_map = entry.columns.each_with_object({}) do |column, mapping|
          mapping[column] = datatype_map(entry[column])
        end

        Alba.serialize(data) do
          attributes **attribute_map
        end
      end

      def datatype_map(datatype)
        case datatype
        when Time
          [String, ->(object) { object.strftime('%F %T') }]
        when NilClass
          [String, ->(object) { nil }]
        else
          [datatype.class, true]
        end
      end

    module ClassMethods
      attr_reader :resource_class

      def resource(resource_class)
        @resource_class = resource_class
      end
    end
  end
end

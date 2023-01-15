module LightningApi
  class Resolver
    include Utils::Underscore

    attr_reader :user, :dataset

    def initialize(user:, dataset:)
      @user = user
      @dataset = dataset
    end

    def resolve(params:)
      _dataset = if dataset.respond_to?(inferred_dataset_method)
                   dataset.send(inferred_dataset_method)
                 else
                   inferred_dataset_class
                 end

      raise_inferred_class_error unless _dataset

      return _dataset unless params[inferred_dataset_parameter]

      _dataset.where(id: params[inferred_dataset_parameter]).first
    end

    private

    def class_name
      @class_name ||= dataset.class.name.rpartition('::').last
    end

    def base_module_name
      @base_module_name ||= dataset.class.name.partition('::').first
    end

    def inferred_dataset_method
      @inferred_dataset_method ||= :"#{self.class.underscore(class_name)}s_dataset"
    end

    def inferred_dataset_class
      @inferred_dataset_class ||= Object.const_get("#{base_module_name}::Models::#{class_name}")
    rescue NameError
      nil
    end

    def inferred_dataset_parameter
      @inferred_dataset_parameter ||= :"#{self.class.underscore(class_name)}_id"
    end

    def raise_inferred_class_error
      raise InferredClassError,
            "Please define a 'resolve' method, because we cannot infer a dataset class"
    end
  end
end

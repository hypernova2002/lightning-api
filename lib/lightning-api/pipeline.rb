module LightningApi
  module Pipeline
    include Utils::CamelCase

    def self.included(base)
      base.extend ClassMethods
      base.extend Utils::CamelCase::ClassMethods
    end

    def run_pipeline
      performers.each do |performer|
        send("call_#{performer}")
      end
    end

    private

    def performers
      @performers ||= self.class.pipeline_performers ||
                      (if self.class.superclass.respond_to?(:pipeline_performers)
                         self.class.superclass.pipeline_performers
                       else
                         []
                       end)
    end

    module ClassMethods
      attr_reader :pipeline_performers

      def pipeline(*performers)
        @pipeline_performers = performers

        namespace = name ? name.rpartition('::').first : ''
        namespace_module = namespace.empty? ? Object : Object.const_get(namespace)

        pipeline_performers.each do |performer|
          performer_class = namespace_module.const_get(camel_case(performer))
          include performer_class
        end
      end
    end
  end
end

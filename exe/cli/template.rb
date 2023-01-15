require 'erb'

module LightningApi
  module CLI
    class Template
      attr_reader :dir

      def initialize(dir: nil)
        @dir = dir || template_location
      end

      def read(template_name)
        File.read(File.join(dir, "#{template_name}.erb"))
      end

      def write(filename, file_dir: nil, content: '', **vars)
        full_filename = file_dir.nil? ? File.join(dir, filename) : File.join(file_dir, filename)
        erb_template = ERB.new(content)
        result = vars.empty? ? erb_template.result : erb_template.result_with_hash(**vars)

        $stdout.puts "Writing file #{full_filename}"
        File.write(full_filename, result)
      end

      private

        def template_location
          current_path = caller_locations(1, 1).first.path
          File.expand_path(File.join(current_path, '..', 'templates'))
        end
    end
  end
end

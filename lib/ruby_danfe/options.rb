module RubyDanfe
  class Options < OpenStruct

    DEFAULTOPTIONS = {
      logo_path: ""
    }

    def initialize(new_options={})
      options = DEFAULTOPTIONS.merge(config_yaml_load)
      super options.merge(new_options)
    end

    private
      def file
        File.exists?("config/ruby_danfe.yml") ? File.open("config/ruby_danfe.yml").read : ""
      end

      def config_yaml_load
        @file_read = YAML.load(file)
        @file_read ? (@file_read["ruby_danfe"]||{})["options"] : {}
      end
  end
end

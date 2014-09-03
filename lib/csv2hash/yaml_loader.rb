require 'active_support/core_ext'
require 'yaml'

module Csv2hash
  class YamlLoader

    attr_reader :conf
    attr_accessor :definition

    def initialize file
      @conf = load_config_file file
      self.conf.deep_symbolize_keys!
    end

    def load!
      mapping         = self.conf.fetch(:mapping)
      header_size     = self.conf.fetch(:header_size).to_i
      structure_rules = self.conf.fetch(:structure_rules)

      self.definition = Main.generate_definition self.conf.fetch(:name) do
        set_type            { mapping }
        set_header_size     { header_size }
        set_structure_rules { structure_rules }
      end

      self.conf.fetch(:rules).each do |rule|
        definition.cells << Cell.new(rule)
      end

      Main[self.conf.fetch(:name)] = self.definition
    end

    private

    def load_config_file file
      if file.to_s =~ /(?<ext>\.erb\.)/
        YAML.load(ERB.new(File.read(file)).result)
      else
        YAML.load_file(file)
      end
    end

  end
end

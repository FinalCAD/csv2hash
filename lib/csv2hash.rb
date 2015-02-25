require_relative 'csv2hash/version'
require_relative 'csv2hash/configuration'
require_relative 'csv2hash/registry'
require_relative 'csv2hash/cell'
require_relative 'csv2hash/definition'
require_relative 'csv2hash/validator'
require_relative 'csv2hash/validator/mapping'
require_relative 'csv2hash/validator/collection'
require_relative 'csv2hash/structure_validator'
require_relative 'csv2hash/structure_validator/max_columns'
require_relative 'csv2hash/structure_validator/min_columns'
require_relative 'csv2hash/parser'
require_relative 'csv2hash/parser/mapping'
require_relative 'csv2hash/parser/collection'
require_relative 'csv2hash/csv_array'
require_relative 'csv2hash/data_wrapper'
require_relative 'csv2hash/notifier'
require_relative 'csv2hash/extra_validator'
require_relative 'csv2hash/adapters/base'
require_relative 'csv2hash/yaml_loader'
require_relative 'csv2hash/coercers/type_coercer'
require_relative 'csv2hash/errors'

require 'csv2hash/railtie' if defined?(Rails)

require 'active_support/core_ext/array/extract_options'

begin
  require 'pry'
rescue LoadError
end

module Csv2hash

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Main
    include StructureValidator

    class << self

      def generate_definition name, &block
        definition = Definition.new name, &block
        Main[name] = definition
      end

      def [] definition_name
        @@registry[definition_name.to_sym]
      end

      def []= definition_name, role
        @@registry[definition_name.to_sym] = role
      end
    end

    @@registry = Registry.new

    attr_accessor :definition, :file_path_or_data, :data, :notifier, :break_on_failure, :errors, :options

    def initialize *args
      self.options = args.extract_options!
      definition_file_or_symbol, file_path_or_data = args

      unless block_given? ^ file_path_or_data
        raise ArgumentError, 'Either value or block must be given, but not both'
      end

      self.file_path_or_data = file_path_or_data || yield
      self.definition        = load_definition(definition_file_or_symbol)
      self.break_on_failure  = false
      self.errors            = []
      self.notifier          = Notifier.new

      dynamic_lib_loading 'Parser'
      dynamic_lib_loading 'Validator'

      @data_source = data_source

      init_plugins
    end

    def init_plugins
      begin
        @plugins = []
        ::Csv2hash::Plugins.constants.each do |name|
          @plugins << ::Csv2hash::Plugins.const_get(name).new(self)
        end
      rescue; end
    end

    def parse!
      self.break_on_failure = true
      parse
    ensure
      self.break_on_failure = false
    end

    def parse
      load_data_source

      definition.validate!
      definition.default!
      validate_structure!
      validate_data!

      DataWrapper.new.tap do |response|
        if valid?
          fill!
          TypeCoercer.new(data[:data]).deserialize! if Csv2hash.configuration.convert
          response.data = data[:data]
        else
          response.valid = false
          response.errors = csv_with_errors
          notifier.notify response
        end
      end
    end

    def csv_with_errors
      @csv_with_errors ||= begin
        CsvArray.new.tap do |rows|
          errors.each do |error|
            rows << error.merge({ value: (data_source[error[:y]][error[:x]] rescue nil) })
          end
        end #.to_csv
      end
    end

    # protected

    def data_source
      @data_source ||= begin
        self.file_path_or_data = Pathname(self.file_path_or_data) if self.file_path_or_data.is_a?(String)
        adapter_name = self.file_path_or_data.respond_to?(:to_path) ? :csv : :memory
        adapter = Adapter::Base.create(adapter_name, self.file_path_or_data)
        adapter.source
      end
    end
    alias_method :load_data_source, :data_source

    private

    def dynamic_lib_loading type
      case definition.type
      when Csv2hash::Definition::MAPPING
        self.extend Module.module_eval("Csv2hash::#{type}::Mapping")
      when Csv2hash::Definition::COLLECTION
        self.extend Module.module_eval("Csv2hash::#{type}::Collection")
      end
    end

    def load_definition definition_file_or_symbol
      case definition_file_or_symbol
      when String
        config_file = definition_file_or_symbol
        config_file = Pathname(definition_file_or_symbol) unless config_file.respond_to?(:to_path)
        loader      = YamlLoader.new(config_file).tap &:load!
        loader.definition
      when Symbol
        Main[definition_file_or_symbol]
      when Definition
        definition_file_or_symbol
      else
        raise 'unsupported definition'
      end
    end

  end
end

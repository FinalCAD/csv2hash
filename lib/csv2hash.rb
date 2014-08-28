require_relative 'csv2hash/version'
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

require 'active_support/core_ext/array/extract_options'

begin
  require 'pry'
rescue LoadError
end

module Csv2hash
  class Main
    include Csv2hash::StructureValidator

    attr_accessor :definition, :file_path_or_data, :data, :notifier, :break_on_failure, :errors, :options

    def initialize definition, file_path_or_data, *args
      self.options = args.extract_options!
      self.definition, self.file_path_or_data = definition, file_path_or_data
      self.break_on_failure, self.errors = false, []
      self.notifier = Notifier.new

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

      Csv2hash::DataWrapper.new.tap do |response|
        if valid?
          fill!
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
        adapter_name = self.file_path_or_data.is_a?(String) ? :csv : :memory
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
  end
end

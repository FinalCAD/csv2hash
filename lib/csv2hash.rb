require 'csv2hash/version'
require 'csv2hash/definition'
require 'csv2hash/validator'
require 'csv2hash/validator/mapping'
require 'csv2hash/validator/collection'
require 'csv2hash/parser'
require 'csv2hash/parser/mapping'
require 'csv2hash/parser/collection'
require 'csv2hash/csv_array'
require 'csv2hash/data_wrapper'
require 'csv2hash/notifier'

require 'csv'

class Csv2hash

  attr_accessor :definition, :file_path, :data, :data_source, :notifier, :exception_mode, :errors

  def initialize definition, file_path, exception_mode=true
    self.definition, self.file_path = definition, file_path
    dynamic_lib_loading 'Parser'
    self.exception_mode, self.errors = exception_mode, []
    dynamic_lib_loading 'Validator'
    self.notifier = Notifier.new
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

  def parse
    load_data_source
    definition.validate!
    definition.default!
    validate_data!

    response = Csv2hash::DataWrapper.new

    if valid?
      fill!
      response.data = data[:data]
    else
      response.valid = false
      response.errors = csv_with_errors
      notifier.notify response
    end

    response
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
    @data_source ||= CSV.read @file_path
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
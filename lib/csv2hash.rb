require 'csv2hash/version'
require 'csv2hash/definition'
require 'csv2hash/validator'
require 'csv2hash/validator/mapping'
require 'csv2hash/validator/collection'
require 'csv2hash/parser'
require 'csv2hash/parser/mapping'
require 'csv2hash/parser/collection'
require 'csv2hash/csv_array'
require 'csv'

class Csv2hash

  attr_accessor :definition, :file_path, :data, :data_source

  def initialize definition, file_path, exception=true
    @definition, @file_path = definition, file_path
    # dynamic_lib_loading Parser
    dynamic_parser_loading
    @exception, @errors = exception, []
    dynamic_validator_loading
    # dynamic_lib_loading Validator
  end

  def parse
    load_data_source
    definition.validate!
    definition.default!
    validate_data!
    if valid?
      fill!
      data
    else
      csv_with_errors
    end
  end

  def csv_with_errors
    @csv_with_errors ||= begin
      CsvArray.new.tap do |rows|
        errors.each do |error|
          rows << (([data_source[error[:x]][error[:y]]]||[nil]) + [error[:message]])
        end
      end.to_csv
    end
  end

  # protected

  def data_source
    @data_source ||= CSV.read @file_path
  end
  alias_method :load_data_source, :data_source

  private

  # "Kaa::#{'Foo'}".constantize.new.bar

  # def dynamic_lib_loading type
  #   case definition.type
  #   when Csv2hash::Definition::MAPPING
  #     self.extend module_eval("Csv2hash::#{type}::Mapping")
  #   when Csv2hash::Definition::COLLECTION
  #     self.extend module_eval("Csv2hash::#{type}::Collection")
  #   end
  # end

  def dynamic_validator_loading
    case definition.type
    when Csv2hash::Definition::MAPPING
      self.extend Csv2hash::Validator::Mapping
    when Csv2hash::Definition::COLLECTION
      self.extend Csv2hash::Validator::Collection
    end
  end

  def dynamic_parser_loading
    case definition.type
    when Csv2hash::Definition::MAPPING
      self.extend Csv2hash::Parser::Mapping
    when Csv2hash::Definition::COLLECTION
      self.extend Csv2hash::Parser::Collection
    end
  end

end
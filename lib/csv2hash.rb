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
    dynamic_parser_loading
    @exception, @errors = exception, []
    dynamic_validator_loading
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

  def dynamic_validator_loading
    case definition.type
    when Csv2Hash::Definition::MAPPING
      self.extend Csv2Hash::Validator::Mapping
    when Csv2Hash::Definition::COLLECTION
      self.extend Csv2Hash::Validator::Collection
    end
  end

  def dynamic_parser_loading
    case definition.type
    when Csv2Hash::Definition::MAPPING
      self.extend Csv2Hash::Parser::Mapping
    when Csv2Hash::Definition::COLLECTION
      self.extend Csv2Hash::Parser::Collection
    end
  end

end

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
    CsvArray.new.tap do |rows|
      errors.each do |error|
        rows << (([data_source[error[:x]][error[:y]]]||[nil]) + [error[:message]])
      end
    end.to_csv
  end

  protected

  def data_source
    @data_source ||= CSV.read @file_path
  end

  private

  def dynamic_validator_loading
    case definition.type
    when Definition::MAPPING
      self.extend Validator::Mapping
    when Definition::COLLECTION
      self.extend Validator::Collection
    end
  end

  def dynamic_parser_loading
    case definition.type
    when Definition::MAPPING
      self.extend Parser::Mapping
    when Definition::COLLECTION
      self.extend Parser::Collection
    end
  end

end
require 'csv2hash/version'
require 'csv2hash/definition'
require 'csv2hash/definition/mapping'
require 'csv2hash/validator'
require 'csv2hash/parser'
require 'csv'

class Csv2hash
  include Validator
  include Parser

  attr_accessor :definition, :file_path, :data, :data_source

  def initialize definition, file_path
    @definition, @file_path = definition, file_path
  end

  def parse
    definition.validate!
    definition.default!
    validate_data!
    fill!
    @data
  end

  protected

  def data_source
    @data_source ||= CSV.read @file_path
  end

end
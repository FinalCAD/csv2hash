module Csv2hash::Validator::Mapping
  include Csv2hash::Validator

  def validate_data!
    validate_rules data_source
  end

  protected

  def position _position
    _position
  end

end

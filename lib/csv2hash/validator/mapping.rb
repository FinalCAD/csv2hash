module Csv2Hash::Validator::Mapping
  include Csv2Hash::Validator

  def validate_data!
    validate_rules data_source
  end

  protected

  def position _position
    _position
  end

end

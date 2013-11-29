module Validator::Collection
  include Validator

  def validate_data!
    @data_source.each_with_index do |line, y|
      validate_line line, y
    end
  end

  protected

  def position _position
    [_position, nil]
  end

end
module Csv2hash::Validator::Collection
  include Csv2hash::Validator

  def validate_data!
    @data_source.each_with_index do |line, y|
      next if y < definition.header_size
      validate_rules y
    end
  end

  protected

  def position _position
    [nil, _position]
  end

end

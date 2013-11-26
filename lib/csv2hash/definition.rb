class Definition

  MAPPING = 'mapping'
  COLLECTION = 'collection'

  attr_accessor :type

  def mapping &block
    @mapping ||= block
  end

end
require 'spec_helper'

describe Definition do

  subject do
    Definition.new.tap do |definition|
      definition.type = Definition::MAPPING
      definition.mapping do
        [
          { position: [0,0], key: 'name' }
        ]
      end
    end
  end

  it '' do
    subject.type.should eql Definition::MAPPING
  end

end

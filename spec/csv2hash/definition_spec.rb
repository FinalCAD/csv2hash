require 'spec_helper'

describe Definition do

  subject do
    Definition.new.tap do |definition|
      definition.type = Definition::MAPPING
      definition.mapping = begin
        [
          { position: [0,0], key: 'name' }
        ]
      end
    end
  end

  it 'variable should be assigned' do
    subject.type.should eql Definition::MAPPING
    subject.mapping.should eql [ { position: [0,0], key: 'name' } ]
  end

end

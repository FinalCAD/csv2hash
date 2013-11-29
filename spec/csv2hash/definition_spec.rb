require 'spec_helper'

describe Definition do

  context 'regular context' do
    subject do
      Definition.new(
        [ { position: [0,0], key: 'name' } ],
        Definition::MAPPING
      )
    end

    it 'variable should be assigned' do
      subject.type.should eql Definition::MAPPING
      subject.rules.should eql [ { position: [0,0], key: 'name' } ]
    end
  end

  describe '#validate!' do
    context 'rules failling validation' do
      subject do
        Definition.new nil, 'unsuitable_type'
      end
      it 'should throw exception' do
        expect {
          subject.validate!
        }.to raise_error "not suitable type, please use '#{Definition::MAPPING}' or '#{Definition::COLLECTION}'"
      end
    end
    context 'rules failling validation' do
      subject do
        Definition.new 'rules',Definition::MAPPING
      end
      it 'should throw exception' do
        expect { subject.validate! }.to raise_error 'rules must be an Array of rules'
      end
    end
  end

  describe '#default!' do
    subject do
      Definition.new [ { position: [0,0], key: 'name' } ], Definition::MAPPING
    end

    before { subject.default! }

    it 'missing key must be filled' do
      subject.rules.should eql([{ position: [0, 0],
        key: 'name',
        message: 'undefined :key on :position',
        mappable: true,
        type: 'string',
        values: nil,
        nested: nil,
        allow_blank: false }])
    end
  end
end





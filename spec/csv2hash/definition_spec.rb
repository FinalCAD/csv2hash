require 'spec_helper'

describe Csv2Hash::Definition do

  context 'regular context' do
    subject do
      Csv2Hash::Definition.new(
        [ { position: [0,0], key: 'name' } ],
        Csv2Hash::Definition::MAPPING
      )
    end

    it 'variable should be assigned' do
      subject.type.should eql Csv2Hash::Definition::MAPPING
      subject.rules.should eql [ { position: [0,0], key: 'name' } ]
    end
  end

  describe '#validate!' do
    context 'rules failling validation' do
      subject do
        Csv2Hash::Definition.new nil, 'unsuitable_type'
      end
      it 'should throw exception' do
        expect {
          subject.validate!
        }.to raise_error "not suitable type, please use '#{Csv2Hash::Definition::MAPPING}' or '#{Csv2Hash::Definition::COLLECTION}'"
      end
    end
    context 'rules failling validation' do
      subject do
        Csv2Hash::Definition.new 'rules',Csv2Hash::Definition::MAPPING
      end
      it 'should throw exception' do
        expect { subject.validate! }.to raise_error 'rules must be an Array of rules'
      end
    end
  end

  describe '#default!' do
    subject do
      Csv2Hash::Definition.new [ { position: [0,0], key: 'name' } ], Csv2Hash::Definition::MAPPING
    end

    before { subject.default! }

    it 'missing key must be filled' do
      subject.rules.should eql([{ position: [0, 0],
        key: 'name',
        message: 'undefined :key on :position',
        type: 'string',
        values: nil,
        nested: nil,
        allow_blank: false }])
    end
  end
end





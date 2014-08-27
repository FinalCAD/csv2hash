require 'spec_helper'

describe Csv2hash::Definition do

  let(:valid_rules) { [ { position: [0,0], key: 'name' } ] }
  context 'regular context' do
    subject do
      Csv2hash::Definition.new(
        valid_rules,
        Csv2hash::Definition::MAPPING
      )
    end

    it 'variable should be assigned' do
      expect(subject.type).to eql Csv2hash::Definition::MAPPING
      expect(subject.rules).to eql [ { position: [0,0], key: 'name' } ]
    end
  end

  describe '#validate!' do
    context 'rules failling validation' do
      subject do
        Csv2hash::Definition.new nil, 'unsuitable_type'
      end
      it 'should throw exception' do
        expect {
          subject.validate!
        }.to raise_error("not suitable type, please use '#{Csv2hash::Definition::MAPPING}' " \
          "or '#{Csv2hash::Definition::COLLECTION}'")
      end
    end
    context 'rules failling validation' do
      subject do
        Csv2hash::Definition.new 'rules',Csv2hash::Definition::MAPPING
      end
      it 'should throw exception' do
        expect { subject.validate! }.to raise_error 'rules must be an Array of rules'
      end
    end

    context 'structure rules failling validation' do
      subject do
        Csv2hash::Definition.new valid_rules, Csv2hash::Definition::MAPPING, { structure_rules: 'invalid structure rule' }
      end
      it 'should throw exception' do
        expect { subject.validate! }.to raise_error 'structure rules must be a Hash of rules'
      end
    end
  end

  describe '#default!' do
    subject do
      Csv2hash::Definition.new [ { position: [0,0], key: 'name' } ], Csv2hash::Definition::MAPPING
    end

    before { subject.default! }

    it 'missing key must be filled' do
      expect(subject.rules).to eql([{ position: [0, 0],
        key: 'name',
        message: 'undefined :key on :position',
        mappable: true,
        type: 'string',
        values: nil,
        nested: nil,
        allow_blank: false,
        extra_validator: nil }])
    end
  end
end

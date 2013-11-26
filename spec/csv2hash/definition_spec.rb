require 'spec_helper'

describe Definition do

  context 'regular context' do
    subject do
      Definition.new.tap do |definition|
        definition.type = Definition::MAPPING
        definition.rules = begin
          [
            { position: [0,0], key: 'name' }
          ]
        end
      end
    end

    it 'variable should be assigned' do
      subject.type.should eql Definition::MAPPING
      subject.rules.should eql [ { position: [0,0], key: 'name' } ]
    end
  end

  describe '#validate!' do
    context 'rules failling validation' do
      subject do
        Definition.new.tap do |definition|
          definition.type = 'unsuitable_type'
        end
      end
      it 'should throw exception' do
        expect {
          subject.validate!
        }.to raise_error "not suitable type, please use '#{Definition::MAPPING}' or '#{Definition::COLLECTION}'"
      end
    end
    context 'rules failling validation' do
      subject do
        Definition.new.tap do |definition|
          definition.type = Definition::MAPPING
          definition.rules = 'rules'
        end
      end
      it 'should throw exception' do
        expect { subject.validate! }.to raise_error 'rules must be an Array of rules'
      end
    end
  end

  describe '#set_default!' do
    subject do
      Definition.new.tap do |definition|
        definition.type = Definition::MAPPING
        definition.rules = begin
          [
            { position: [0,0], key: 'name' }
          ]
        end
      end
    end

    before { subject.set_default! }

    it 'missing key must be filled' do
      subject.rules.should eql([{ position: [0, 0],
        key: 'name',
        message: 'undefined key on position',
        mappable: true,
        type: 'string',
        values: nil,
        nested: nil,
        allow_blank: false,
        maptype: 'cell' }])
    end
  end
end





require 'spec_helper'

describe Validator do

  let(:definition) do
    Definition.new.tap do |definition|
      definition.type = Definition::MAPPING
      definition.rules = [ { position: [0,0], key: 'name' } ]
      definition.validate!
      definition.default!
    end
  end

  subject do
    Csv2hash.new definition, data_source
  end

  context 'with valid data' do
    let(:data_source) { [ [ 'John Doe' ] ]}
    it { expect { subject.validate_data! }.to_not raise_error }
  end

  context 'with invalid data' do
    let(:data_source) { [ [ ] ]}
    it { expect { subject.validate_data! }.to raise_error('undefined name on [0, 0]') }
  end

  describe '#message' do
    subject { Csv2hash.new nil, nil }

    context 'string value' do
      let(:rule) { { foo: 'bar', message: ':foo are value of foo key' } }

      it 'substitue value of key' do
        subject.send(:message, rule).should eql 'bar are value of foo key'
      end
    end

    context 'array value' do
      let(:rule) { { foo: ['bar', 'zone'], message: ':foo are values of foo key' } }

      it 'substitue value of key' do
        subject.send(:message, rule).should eql '["bar", "zone"] are values of foo key'
      end
    end
  end
end

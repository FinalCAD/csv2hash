require 'spec_helper'

describe Validator do

  let(:definition) do
    Definition.new([ { position: [0,0], key: 'name' } ], Definition::MAPPING).tap do |definition|
      definition.validate!
      definition.default!
    end
  end

  subject do
    Csv2hash.new(definition, 'file_path').tap do |csv2hash|
      csv2hash.data_source = data_source
    end
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
    subject { Csv2hash.new double('definition', type: 'unknow'), nil }

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

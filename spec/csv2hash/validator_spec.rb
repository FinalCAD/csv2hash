require 'spec_helper'

describe Csv2hash::Validator do

  let(:definition) do
    Csv2hash::Definition.new([ { position: [0,0], key: 'name' } ], Csv2hash::Definition::MAPPING).tap do |definition|
      definition.validate!
      definition.default!
    end
  end

  subject do
    Csv2hash.new(definition, 'file_path').tap do |csv2hash|
      csv2hash.data_source = data_source
    end
  end

  describe '#message' do
    subject { Csv2hash.new double('definition', type: Csv2hash::Definition::COLLECTION), nil }

    context 'string value' do
      let(:rule) { { foo: 'bar', message: ':foo are value of foo key' } }

      it 'substitue value of key' do
        subject.send(:message, rule, nil, nil).should eql 'bar are value of foo key'
      end
    end

    context 'array value' do
      let(:rule) { { foo: ['bar', 'zone'], message: ':foo are values of foo key' } }

      it 'substitue value of key' do
        subject.send(:message, rule, nil, nil).should eql '["bar", "zone"] are values of foo key'
      end
    end

    context 'with position' do
      let(:rule) { { message: 'value not found on :position' } }

      it 'substitue value of key' do
        subject.send(:message, rule, 0, 2).should eql 'value not found on [0, 2]'
      end
    end
  end

end

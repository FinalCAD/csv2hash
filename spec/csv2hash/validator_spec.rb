require 'spec_helper'

describe Csv2hash::Validator do

  let(:definition) do
    Csv2hash::Definition.new([ { position: [0,0], key: 'name' } ], Csv2hash::Definition::MAPPING).tap do |definition|
      definition.validate!
      definition.default!
    end
  end

  describe '#message' do
    subject { Csv2hash.new double('definition', type: Csv2hash::Definition::COLLECTION), nil }

    context 'string value' do
      let(:rule) { { foo: 'bar', message: ':foo are value of foo key' } }

      it 'substitue value of key' do
        expect(subject.send(:message, rule, nil, nil)).to eql 'bar are value of foo key'
      end
    end

    context 'array value' do
      let(:rule) { { foo: ['bar', 'zone'], message: ':foo are values of foo key' } }

      it 'substitue value of key' do
        expect(subject.send(:message, rule, nil, nil)).to eql '["bar", "zone"] are values of foo key'
      end
    end

    context 'with position' do
      let(:rule) { { message: 'value not found on :position' } }

      it 'substitue value of key' do
        expect(subject.send(:message, rule, 0, 2)).to eql 'value not found on [0, 2]'
      end
    end
  end

end

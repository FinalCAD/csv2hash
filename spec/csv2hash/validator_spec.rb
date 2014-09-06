require 'spec_helper'

module Csv2hash
  describe 'Validator' do

    describe '#message' do
      let(:cell) { double(:cell, rules: rules) }

      subject do
        Class.new do
          include Validator
        end.new
      end

      context 'string value' do
        let(:rules) {{ foo: 'bar', message: ':foo are value of foo key', key: 'bar' }}

        it 'substitue value of key' do
          expect(subject.send(:message, cell, nil, nil, 'foo')).to eql 'bar are value of foo key'
        end
      end

      context 'array value' do
        let(:rules) { { foo: ['bar', 'zone'], message: ':foo are values of foo key' } }

        it 'substitue value of key' do
          expect(subject.send(:message, cell, nil, nil, nil)).to eql '["bar", "zone"] are values of foo key'
        end
      end

      context 'with position' do
        let(:rules) { { message: 'value not found on :position' } }

        it 'substitue value of key' do
          expect(subject.send(:message, cell, 0, 2, nil)).to eql 'value not found on [0, 2]'
        end
      end
    end

  end
end

require 'spec_helper'

module Csv2hash
  describe 'Validator' do

    subject do
      Class.new do
        include Validator
      end.new
    end

    describe '#message' do
      let(:cell) { double(:cell, rules: rules) }

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

    describe '#validate_cell' do
      let(:x)           { 0 }
      let(:y)           { 0 }
      let(:allow_blank) { false }
      let(:values)      { nil } 
      let(:data_source) { [ ['John Doe'] ]}
      let(:rules)       { { position: [x, y],
                            key: 'name',
                            message: 'undefined :key on :position',
                            mappable: true,
                            type: 'string',
                            values: values,
                            nested: nil,
                            allow_blank: allow_blank,
                            extra_validator: nil }}
      let(:cell)        { Cell.new(rules) }
      
      before do 
        allow(subject).to receive(:break_on_failure) { true }
        allow(subject).to receive(:data_source) { data_source }  
      end

      context 'when default cell' do
        it{ expect{ subject.send(:validate_cell, x, y, cell) }.to_not raise_error }
      end

      context 'when allow_blank is false and data source value is blank' do
        let(:data_source) { [ [''] ]}
        let(:allow_blank) { false }
        it{ expect{ subject.send(:validate_cell, x, y, cell) }.to raise_error 'undefined :name on [0, 0]' }        
      end

      context 'when allow_blank is true and data source value is blank' do
        let(:data_source) { [ [''] ]}
        let(:allow_blank) { true }
        it{ expect{ subject.send(:validate_cell, x, y, cell) }.to_not raise_error }

        context 'and values are not nil' do
          let(:values) { ['yes', 'no'] }
          it{ expect{ subject.send(:validate_cell, x, y, cell) }.to_not raise_error }
        end        
      end        
    end
  end
end

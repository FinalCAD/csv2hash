require 'spec_helper'

describe Csv2hash::StructureValidator do

  let(:rules) { [ { position: [0,0], key: 'name' } ] }
  let(:options) { {} }
  let(:break_on_failure) { true }
  let(:definition) do
    Csv2hash::Definition.new(rules, Csv2hash::Definition::MAPPING, options).tap do |definition|
      definition.validate!
      definition.default!
    end
  end

  subject do
    Csv2hash::Main.new(definition, data_source, break_on_failure, ignore_blank_line=false)
  end

  context 'the csv with errors' do
    let(:options){ { structure_rules: { 'MaxColumns' => 2 } } }
    let(:break_on_failure) { false }
    before { subject.parse }
    let(:data_source) do
      [
        [ 'John', 'Doe' ],
        [ 'Jane', 'Doe', 'extra field' ]
      ]
    end

    its(:csv_with_errors) { should be_kind_of CsvArray }
    it "adds structure error in first cell" do
      expect(subject.csv_with_errors.first[:message]).to eq 'Too many columns (max. 2) on line 1'
    end
  end


  context '#MaxColumns'  do
    let(:options){ { structure_rules: { 'MaxColumns' => 2 } } }

    context 'valid data' do
      let(:data_source) do
        [
          [ 'John', 'Doe' ]
        ]
      end
      it { expect { subject.validate_structure! }.to_not raise_error }
    end

    context 'invalid data' do
      let(:data_source) do
        [
          [ 'John', 'Doe' ],
          [ 'Jane', 'Doe', 'extra field' ]
        ]
      end
      it { expect { subject.validate_structure! }.to raise_error 'Too many columns (max. 2) on line 1' }
    end
  end

  context '#MinColumns'  do
    let(:options){ { structure_rules: { 'MinColumns' => 2 } } }

    context 'valid data' do
      let(:data_source) do
        [
          [ 'John', 'Doe', 'foo' ]
        ]
      end
      it { expect { subject.validate_structure! }.to_not raise_error }
    end

    context 'invalid data' do
      let(:data_source) do
        [
          [ 'John' ],
          [ 'Jane', 'Doe' ]
        ]
      end
      it { expect { subject.validate_structure! }.to raise_error 'Not enough columns (min. 2) on line 0' }
    end
  end

end

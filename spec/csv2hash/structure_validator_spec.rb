require 'spec_helper'

describe Csv2hash::StructureValidator do

  let(:rules) { [ { position: [0,0], key: 'name' } ] }
  let(:options) { {} }
  let(:exception_mode) { true }
  let(:definition) do
    Csv2hash::Definition.new(rules, Csv2hash::Definition::MAPPING, options).tap do |definition|
      definition.validate!
      definition.default!
    end
  end

  subject do
    Csv2hash.new(definition, 'file_path', exception_mode, data_source)
  end

  context 'the csv with errors' do
    let(:options){ { structure_rules: { 'MaxColumns' => 2 } } }
    let(:exception_mode) { false }
    before { subject.parse }
    let(:data_source) do
      [
        [ 'John', 'Doe' ],
        [ 'Jane', 'Doe', 'extra field' ]
      ]
    end

    its(:csv_with_errors) { should be_kind_of CsvArray }
    it "adds structure error in first cell" do
      subject.csv_with_errors.first[:message].should eq 'Too many columns (max. 2) on line 1'
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
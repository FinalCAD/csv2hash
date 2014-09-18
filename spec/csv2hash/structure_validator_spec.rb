require 'spec_helper'

module Csv2hash
  describe StructureValidator do
    let(:definition) do
      Main.generate_definition :foo do
        set_type { Definition::MAPPING }
        mapping { cell position: [0,0], key: 'name' }
      end.tap { |d| d.validate! ; d.default! }
    end

    subject do
      Main.new(definition, ignore_blank_line: false) do
        data_source
      end
    end

    context 'the csv with errors' do
      before do
        allow(definition).to receive(:structure_rules) {{ max_columns: 2 }}
        subject.parse
      end
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
      before do
        allow(definition).to receive(:structure_rules) {{ max_columns: 2 }}
        allow(subject).to receive(:break_on_failure) { true }
      end

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
      before do
        allow(definition).to receive(:structure_rules) {{ min_columns: 2 }}
        allow(subject).to receive(:break_on_failure) { true }
      end

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
end

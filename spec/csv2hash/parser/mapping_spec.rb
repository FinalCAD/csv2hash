require 'spec_helper'

module Csv2hash
  describe Parser::Mapping do

    let(:definition) do
      Main.generate_definition :foo do
        set_type { Definition::MAPPING }
        mapping { cell position: [0,0], key: 'name' }
      end
    end

    let(:data_source) { [ [ 'John Doe' ] ] }

    subject do
      Main.new(definition, data_source, ignore_blank_line: false)
    end

    context 'regular way' do
      it { expect { subject.parse! }.to_not raise_error }
      it {
        expect(subject.tap do |csv2hash|
          csv2hash.parse!
        end.data).to eql({ data: [ { 'name' => 'John Doe' } ] })
      }
    end

    context 'with nested' do
      let(:data_source) { [ [ 'John Doe', 22 ] ] }
      before do
        definition.cells << Cell.new({ position: [0,1], key: 'age', nested: 'infos' })
      end
      it {
        expect(subject.tap { |c| c.parse! }.data).to eql(
          { data: [ { 'name' => 'John Doe', 'infos' => { 'age' => 22 } } ] }
        )
      }
    end

  end
end

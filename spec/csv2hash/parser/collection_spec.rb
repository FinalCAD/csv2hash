require 'spec_helper'

module Csv2hash
  describe Parser::Collection do

    let(:definition) do
      Main.generate_definition :foo do
        set_type { Definition::COLLECTION }
        mapping { cell position: 0, key: 'name' }
      end
    end

    let(:data_source) { [ [ 'John Doe' ], [ 'Jane Doe' ] ] }
    let(:ignore_blank_line) { false }

    subject do
      Main.new(definition, data_source, ignore_blank_line: ignore_blank_line)
    end

    context 'regular way' do
      it { expect { subject.parse! }.to_not raise_error }
      it {
        expect(subject.tap do |parser|
          parser.parse!
        end.data).to eql({ data: [ { 'name' => 'John Doe' }, { 'name' => 'Jane Doe' } ] })
      }
      context 'with header' do
        before { subject.definition.header_size = 1 }
        let(:data_source) { [ [ 'Name' ], [ 'John Doe' ], [ 'Jane Doe' ] ] }
        it {
          expect(subject.tap { |c| c.parse }.data).to eql(
            { data: [ { 'name' => 'John Doe' }, { 'name' => 'Jane Doe' } ] })
        }
      end
    end

    context 'with nested' do
      let(:data_source) { [ [ 'John Doe', 22 ], [ 'Jane Doe', 19 ] ] }
      before do
        definition.cells << Cell.new({ position: 1, key: 'age', nested: 'infos' })
      end
      it {
        expect(subject.tap { |c| c.parse! }.data).to eql(
          { data: [
            { 'name' => 'John Doe', 'infos' => { 'age' => 22 } },
            { 'name' => 'Jane Doe', 'infos' => { 'age' => 19 } }
            ]
          }
        )
      }
    end

    context '#ignore_blank_line' do
      let(:data_source) { [ [ 'John Doe' ], [ 'Jane Doe' ], [ nil ] ] }
      let(:ignore_blank_line) { true }
      it {
        expect(subject.tap do |parser|
          parser.parse!
        end.data).to eql({ data: [ { 'name' => 'John Doe' }, { 'name' => 'Jane Doe' } ] })
      }
    end
  end
end

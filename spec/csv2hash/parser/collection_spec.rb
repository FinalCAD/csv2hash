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

    context 'discover' do

      context 'when header keyword present' do
        let(:data_source) { [ ['Name','Age'], [ 'John Doe',34 ], [ 'Jane Doe', 25] ] }
        before do
          subject.definition.header_size = 1
          definition.cells << Cell.new({ position: /Age/, key: 'age' })
          definition.cells << Cell.new({ position: /Name/, key: 'name' })      
        end
        it {
          expect(subject.tap { |c| c.parse! }.data).to eql(
            { data: [ { 'name' => 'John Doe', 'age' => 34 }, { 'name' => 'Jane Doe', 'age' => 25} ] }
          )
        }
      end

      context 'when no header keyword found and no break on failure' do
        let(:data_source) { [ [ 'John Doe',34 ], [ 'Jane Doe', 25] ] }
        before do
          subject.break_on_failure = false
          definition.cells << Cell.new({ position: /Name/, key: 'name' })
          subject.parse
        end
        it{ expect(subject.data).to eql(nil)}
        it{ expect(subject.errors.first[:message]).to eql("Column doesn't found in foo")}
      end

      context 'when no header keyword found and break on failure' do
        let(:data_source) { [ [ 'John Doe',34 ], [ 'Jane Doe', 25] ] }
        before do
          subject.break_on_failure = true
          definition.cells << Cell.new({ position: /Name/, key: 'name' })
        end
        it 'should throw exception' do
          expect {
            subject.parse
          }.to raise_error("Column doesn't found in foo")
        end
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

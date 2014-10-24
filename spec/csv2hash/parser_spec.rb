require 'spec_helper'

module Csv2hash
  describe Parser do
    let(:definition) do
      Main.generate_definition :foo do
        set_type { Definition::COLLECTION }
        mapping { cell position: 0, key: 'name' }
      end
    end

    let(:john) { '   John    Doe   ' }
    let(:jane) { '  Jane     Doe    ' }
    let(:data_source) { [ [ john ], [ jane ] ] }
    let(:ignore_blank_line) { false }

    subject do
      Main.new(definition, data_source, ignore_blank_line: ignore_blank_line, sanitizer: sanitizer)
    end

    context 'regular way' do
      let(:sanitizer) { false }
      it {
        expect(subject.tap do |parser|
          parser.parse!
        end.data).to eql({ data: [ { 'name' => john }, { 'name' => jane } ] })
      }
    end

    context 'sanitizer way' do
      let(:sanitizer) { true }
      it {
        expect(subject.tap do |parser|
          parser.parse!
        end.data).to eql({ data: [ { 'name' => 'John Doe' }, { 'name' => 'Jane Doe' } ] })
      }
    end
  end
end

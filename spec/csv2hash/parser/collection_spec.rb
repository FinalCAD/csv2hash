require 'spec_helper'

describe Csv2hash::Parser::Collection do

  let(:definition) do
    Csv2hash::Definition.new [ { position: 0, key: 'name' } ], Csv2hash::Definition::COLLECTION
  end

  let(:data_source) { [ [ 'John Doe' ], [ 'Jane Doe' ] ] }

  subject do
    Csv2hash.new(definition, 'file_path', false, data_source)
  end

  context 'regular way' do
    it { expect { subject.parse }.to_not raise_error }
    it {
      subject.tap do |csv2hash|
        csv2hash.parse
      end.data.should eql({ data: [ { 'name' => 'John Doe' }, { 'name' => 'Jane Doe' } ] })
    }
    context 'with header' do
      before { subject.definition.header_size = 1 }
      let(:data_source) { [ [ 'Name' ], [ 'John Doe' ], [ 'Jane Doe' ] ] }
      it {
        subject.tap { |c| c.parse }.data.should eql({ data: [ { 'name' => 'John Doe' }, { 'name' => 'Jane Doe' } ] })
      }
    end
  end

  context 'with nested' do
    let(:data_source) { [ [ 'John Doe', 22 ], [ 'Jane Doe', 19 ] ] }
    before do
      definition.rules << { position: 1, key: 'age', nested: 'infos' }
    end
    it {
      subject.tap { |c| c.parse }.data.should eql(
        { data: [
          { 'name' => 'John Doe', 'infos' => { 'age' => 22 } },
          { 'name' => 'Jane Doe', 'infos' => { 'age' => 19 } }
          ]
        }
      )
    }
  end

end

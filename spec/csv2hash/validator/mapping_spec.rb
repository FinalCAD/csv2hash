require 'spec_helper'

describe Csv2Hash::Validator::Mapping do

  let(:definition) do
    Csv2Hash::Definition.new([ { position: [0,0], key: 'name' } ], Csv2Hash::Definition::MAPPING).tap do |definition|
      definition.validate!
      definition.default!
    end
  end

  subject do
    Csv2hash.new(definition, 'file_path').tap do |csv2hash|
      csv2hash.data_source = data_source
    end
  end

  context 'with valid data' do
    let(:data_source) { [ [ 'John Doe' ] ]}
    it { expect { subject.validate_data! }.to_not raise_error }
  end

  context 'with invalid data' do
    let(:data_source) { [ [ ] ]}
    it { expect { subject.validate_data! }.to raise_error('undefined name on [0, 0]') }
  end

  context 'wihtout exception' do
    let(:data_source) { [ [ ] ]}
    before { subject.exception = false }
    it { subject.parse.should eql ",\"undefined name on [0, 0]\"\n" }

    context 'errors should be filled' do
      before { subject.parse }
      its(:errors) { should eql [{x: 0, y: 0, message: 'undefined name on [0, 0]', key: 'name'}] }
    end

    context 'original csv + errors should be returned' do
      let(:definition) do
        Csv2Hash::Definition.new(rules, Csv2Hash::Definition::MAPPING).tap do |d|
          d.validate!; d.default!
        end
      end
      context 'string values' do
        let(:rules) do
          [
            { position: [0,0], key: 'agree', values: ['yes', 'no'] },
            { position: [1,0], key: 'agree', values: ['yes', 'no'] },
            { position: [2,0], key: 'agree', values: ['yes', 'no'] }
          ]
        end
        let(:data_source) { [ [ 'what?' ], [ 'yes', 'what?' ], [ 'yes', 'what?', 'no' ] ] }
        it { subject.parse.should eql "what?,\"agree not supported, please use one of [\"\"yes\"\", \"\"no\"\"]\"\n" }
      end
      context 'range values' do
        let(:rules) do
          [
            { position: [0,0], key: 'score', values: 1..10 },
            { position: [1,0], key: 'score', values: 1..10 },
            { position: [2,0], key: 'score', values: 1..10 }
          ]
        end
        let(:data_source) { [ [ 12 ], [ 2, 12 ], [ 3, 12, 1 ] ] }
        it { subject.parse.should eql "12,\"score not supported, please use one of 1..10\"\n" }
      end
    end
  end
end
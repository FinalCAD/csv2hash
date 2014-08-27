require 'spec_helper'

describe Csv2hash::Validator::Collection do
  let(:options) { {} }
  let(:definition) do
    Csv2hash::Definition.new([ { position: 0, key: 'name' } ], Csv2hash::Definition::COLLECTION, options).tap do |definition|
      definition.validate!
      definition.default!
    end
  end

  subject do
    Csv2hash::Main.new(definition, data_source, exception_mode=true, ignore_blank_line=false)
  end

  context 'with valid data' do
    let(:data_source) { [ [ 'John Doe' ] ]}
    it { expect { subject.validate_data! }.to_not raise_error }
    context 'with header' do
      let(:options) { { header_size: 1 } }
      let(:data_source) { [ [ 'Name' ], [ 'John Doe' ] ]}
      it { expect { subject.validate_data! }.to_not raise_error }
    end
  end

  context '#ignore_blank_line' do
    let(:data_source) { [ [ ] ] }
    before { subject.ignore_blank_line = true }
    it { expect { subject.validate_data! }.to_not raise_error }
    context 'csv mode' do
      before { subject.exception_mode = false }
      its(:errors) { should be_empty }
    end
  end

  context 'with invalid data' do
    let(:data_source) { [ [ ] ] }
    it { expect { subject.validate_data! }.to raise_error('undefined name on [0, 0]') }
    context 'with header' do
      let(:options) { { header_size: 1 } }
      let(:data_source) { [ [ 'Name' ], [ ] ]}
      it { expect { subject.validate_data! }.to raise_error('undefined name on [1, 0]') }
    end
  end

  context 'wihtout exception' do
    let(:data_source) { [ [ ] ]}
    before { subject.exception_mode = false }
    it { expect(subject.parse.errors.to_csv).to eql ",\"undefined name on [0, 0]\"\n" }

    context 'errors should be filled' do
      before { subject.parse }
      its(:errors) { should eql [{x: 0, y: 0, message: 'undefined name on [0, 0]', key: 'name'}] }
    end

    context 'original csv + errors should returned' do
      let(:definition) do
        Csv2hash::Definition.new(
          [{ position: 0, key: 'agree', values: ['yes', 'no'] }], Csv2hash::Definition::COLLECTION).tap do |d|
          d.validate!; d.default!
        end
      end
      let(:data_source) { [ [ 'what?' ], [ 'yes' ], [ 'no' ] ] }
      it { expect(subject.parse.errors.to_csv).to eql "what?,\"agree not supported, please use one of [\"\"yes\"\", \"\"no\"\"]\"\n" }
    end
  end

end

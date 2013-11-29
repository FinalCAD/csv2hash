require 'spec_helper'

describe Csv2Hash::Validator::Collection do

  let(:definition) do
    Csv2Hash::Definition.new([ { position: 0, key: 'name' } ], Csv2Hash::Definition::COLLECTION).tap do |definition|
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
    context 'with header' do
      before { subject.definition.header_size = 1 }
      let(:data_source) { [ [ 'Name' ], [ 'John Doe' ] ]}
      it { expect { subject.validate_data! }.to_not raise_error }
    end
  end

  context 'with invalid data' do
    let(:data_source) { [ [ ] ]}
    it { expect { subject.validate_data! }.to raise_error('undefined name on [0, 0]') }
    context 'with header' do
      before { subject.definition.header_size = 1 }
      let(:data_source) { [ [ 'Name' ], [ ] ]}
      it { expect { subject.validate_data! }.to raise_error('undefined name on [0, 1]') }
    end
  end

end

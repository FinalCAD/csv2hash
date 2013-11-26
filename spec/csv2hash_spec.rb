require 'spec_helper'

describe Csv2hash do

  let(:definition) do
    Definition.new.tap do |definition|
      definition.type = Definition::MAPPING
      definition.rules = [ { position: [0,0], key: 'name' } ]
      definition.validate!
      definition.set_default!
    end
  end

  subject do
    Csv2hash.new definition, data_source
  end

  context 'with valid data' do
    let(:data_source) { [ [ 'John Doe' ] ]}
    it { expect { subject.validate_data! }.to_not raise_error }
  end

  context 'with invalid data' do
    let(:data_source) { [ [ ] ]}
    it { expect { subject.validate_data! }.to raise_error('undefined name on [0, 0]') }
  end

end

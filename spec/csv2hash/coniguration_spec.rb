require 'spec_helper'

module Csv2hash
  describe Configuration do
    let(:configuration) { Configuration.new }

    describe '#default' do
      let(:true_values)  { ['yes','y','t'] }
      let(:false_values) { ['no','n','f']  }
      let(:nil_values)   { ['nil','null']  }

      it 'true values' do
        expect(configuration.true_values).to eq(true_values)
      end
    end

  end
end

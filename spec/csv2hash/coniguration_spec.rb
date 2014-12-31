require 'spec_helper'

module Csv2hash
  describe Configuration do
    let(:configuration) { Configuration.new }

    describe '#default' do
      let(:true_values)    { ['yes','y','t'] }
      let(:false_values)   { ['no','n','f']  }
      let(:nil_values)     { ['nil','null']  }
      let(:ignore_case)    { false }
      let(:exact_matching) { false }

      it 'true values' do
        expect(configuration.true_values).to eq(true_values)
      end

      it 'false values' do
        expect(configuration.false_values).to eq(false_values)
      end

      it 'nil values' do
        expect(configuration.nil_values).to eq(nil_values)
      end

      it 'ignore_case' do
        expect(configuration.ignore_case).to eq(ignore_case)
      end

      it 'exact_matching' do
        expect(configuration.exact_matching).to eq(exact_matching)
      end
    end

  end
end

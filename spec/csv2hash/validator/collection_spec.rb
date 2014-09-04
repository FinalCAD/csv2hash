require 'spec_helper'

module Csv2hash
  describe Validator::Collection do
    let(:options) { {} }
    let(:definition) do
      Main.generate_definition :foo do
        set_type { Definition::COLLECTION }
        mapping { cell position: 0, key: 'name' }
      end.tap { |d| d.validate! ; d.default! }
    end
    let(:ignore_blank_line) { false }

    subject do
      Main.new(definition, data_source, ignore_blank_line: ignore_blank_line)
    end

    before do
      allow(subject).to receive(:break_on_failure) { true }
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
      let(:ignore_blank_line) { true }
      it { expect { subject.validate_data! }.to_not raise_error }
      context 'csv mode' do
        before { subject.break_on_failure = false }
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

      before do
        allow(subject).to receive(:break_on_failure) { false }
      end

      it { expect(subject.parse.errors.to_csv).to eql ",\"undefined name on [0, 0]\"\n" }

      context 'errors should be filled' do
        before { subject.parse }
        its(:errors) { should eql [{x: 0, y: 0, message: 'undefined name on [0, 0]', key: 'name'}] }
      end

      context 'original csv + errors should returned' do
        let(:definition) do
          Main.generate_definition :foo do
            set_type { Definition::COLLECTION }
            mapping  { cell position: 0, key: 'agree', values: ['yes', 'no'] }
          end.tap { |d| d.validate! ; d.default! }
        end
        let(:data_source) { [ [ 'what?' ], [ 'yes' ], [ 'no' ] ] }
        it { expect(subject.parse.errors.to_csv).to eql "what?,\"agree not supported, please use one of [\"\"yes\"\", \"\"no\"\"]\"\n" }
      end
    end

  end
end

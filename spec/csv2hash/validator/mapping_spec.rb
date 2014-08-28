require 'spec_helper'

module Csv2hash
  describe Validator::Mapping do

    let(:definition) do
      Main.generate_definition :foo do
        set_type { Definition::MAPPING }
        mapping { cell position: [0,0], key: 'name' }
      end.tap { |d| d.validate! ; d.default! }
    end

    subject do
      Main.new(definition, data_source, ignore_blank_line: false)
    end

    before do
      allow(subject).to receive(:break_on_failure) { true }
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
      let(:data_source) { [ [ ] ] }

      before do
        allow(subject).to receive(:break_on_failure) { false }
      end

      it { expect(subject.parse.errors.to_csv).to eql ",\"undefined name on [0, 0]\"\n" }

      context 'errors should be filled' do
        before { subject.parse }
        its(:errors) { should eql [{x: 0, y: 0, message: 'undefined name on [0, 0]', key: 'name'}] }
      end

      context 'original csv + errors should be returned' do
        let(:definition) do
          Main.generate_definition :foo do
            set_type { Definition::MAPPING }
            mapping do
              cell position: [0,0], key: 'agree', values: ['yes', 'no']
              cell position: [1,0], key: 'agree', values: ['yes', 'no']
              cell position: [2,0], key: 'agree', values: ['yes', 'no']
            end
          end.tap { |d| d.validate! ; d.default! }
        end
        context 'string values' do
          let(:data_source) { [ [ 'what?' ], [ 'yes', 'what?' ], [ 'yes', 'what?', 'no' ] ] }
          it { expect(subject.parse.errors.to_csv).to eql(
            "what?,\"agree not supported, please use one of [\"\"yes\"\", \"\"no\"\"]\"\n") }
        end
        context 'range values' do
          let(:definition) do
            Main.generate_definition :foo do
              set_type { Definition::MAPPING }
              mapping do
                cell position: [0,0], key: 'score', values: 1..10
                cell position: [1,0], key: 'score', values: 1..10
                cell position: [2,0], key: 'score', values: 1..10
              end
            end.tap { |d| d.validate! ; d.default! }
          end
          let(:data_source) { [ [ 12 ], [ 2, 12 ], [ 3, 12, 1 ] ] }
          it { expect(subject.parse.errors.to_csv).to eql("12,\"score not supported, please use one of 1..10\"\n") }
        end
      end

      context 'with extra_validator' do
        let(:definition) do
          Main.generate_definition :foo do
            set_type { Definition::MAPPING }
            mapping do
              cell position: [0,0], key: 'name', extra_validator: DowncaseValidator.new,
                message: 'your data should be writting in downcase only'
            end
          end.tap { |d| d.validate! ; d.default! }
        end
        before { subject.parse }
        context 'not valid data' do
          let(:data_source) { [ [ 'Foo' ] ] }
          its(:errors) do
            should eql [{x: 0, y: 0, message: 'your data should be writting in downcase only', key: 'name'}]
          end
        end
        context 'valid data' do
          let(:data_source) { [ [ 'foo' ] ] }
          its(:errors) { should be_empty }
        end
      end
    end
  end

  class DowncaseValidator < ExtraValidator
    def valid? rule, value
      !!(value.match /^[a-z]+$/)
    end
  end
end

require 'spec_helper'

module Csv2hash
  module Coercers
    describe YamlCoercer do
      let(:base_rules)     {{ key: 'mobile_phone', allow_blank: true }}
      let(:ignore_case)    { false }
      let(:exact_matching) { false }

      context 'deserialize!' do
        subject { YamlCoercer.new(rules) }
        before do
          Csv2hash.configure do |conf|
            conf.ignore_case    = ignore_case
            conf.exact_matching = exact_matching
          end
          subject.deserialize!
        end

        after do
          Csv2hash.configure do |conf|
            conf.ignore_case    = false
            conf.exact_matching = false
          end
        end

        context 'regular' do
          context 'from string' do
            context 'when position is a string' do
              let(:rules)        { base_rules.merge(position: 'Mobile phone number') }
              let(:result_rules) { base_rules.merge(position: /Mobile phone number/) }

              it { expect(subject.rules).to eql(result_rules) }
            end

            context 'when position is a array' do
              let(:rules)        { base_rules.merge(position: [[1, 'Mobile phone number'], 2]) }
              let(:result_rules) { base_rules.merge(position: [[1, /Mobile phone number/], 2]) }

              it { expect(subject.rules).to eql(result_rules) }
            end
          end
          context 'from regex' do
            context 'when position is a string' do
              let(:rules)        { base_rules.merge(position: /Mobile phone number/) }
              let(:result_rules) { base_rules.merge(position: /Mobile phone number/) }

              it { expect(subject.rules).to eql(result_rules) }
            end

            context 'when position is a array' do
              let(:rules)        { base_rules.merge(position: [[1, /Mobile phone number/], 2]) }
              let(:result_rules) { base_rules.merge(position: [[1, /Mobile phone number/], 2]) }

              it { expect(subject.rules).to eql(result_rules) }
            end
          end
        end

        context 'ignore_case' do
          let(:ignore_case) { true }

          context 'when position is a string' do
            let(:rules)        { base_rules.merge(position: 'Mobile phone number') }
            let(:result_rules) { base_rules.merge(position: /Mobile phone number/i) }

            it { expect(subject.rules).to eql(result_rules) }
          end

          context 'when position is a array' do
            let(:rules)        { base_rules.merge(position: [[1, 'Mobile phone number'], 2]) }
            let(:result_rules) { base_rules.merge(position: [[1, /Mobile phone number/i], 2]) }

            it { expect(subject.rules).to eql(result_rules) }
          end
        end

        context 'exact_matching' do
          let(:exact_matching) { true }

          context 'when position is a string' do
            let(:rules)        { base_rules.merge(position: 'Mobile phone number') }
            let(:result_rules) { base_rules.merge(position: /\A(Mobile phone number)\z/) }

            it { expect(subject.rules).to eql(result_rules) }
          end

          context 'when position is a array' do
            let(:rules)        { base_rules.merge(position: [[1, 'Mobile phone number'], 2]) }
            let(:result_rules) { base_rules.merge(position: [[1, /\A(Mobile phone number)\z/], 2]) }

            it { expect(subject.rules).to eql(result_rules) }
          end
        end

        context 'exact_matching and ignore_case' do
          let(:ignore_case)    { true }
          let(:exact_matching) { true }

          context 'when position is a string' do
            let(:rules)        { base_rules.merge(position: 'Mobile phone number') }
            let(:result_rules) { base_rules.merge(position: /\A(Mobile phone number)\z/i) }

            it { expect(subject.rules).to eql(result_rules) }
          end

          context 'when position is a array' do
            let(:rules)        { base_rules.merge(position: [[1, 'Mobile phone number'], 2]) }
            let(:result_rules) { base_rules.merge(position: [[1, /\A(Mobile phone number)\z/i], 2]) }

            it { expect(subject.rules).to eql(result_rules) }
          end
        end

      end
    end
  end
end

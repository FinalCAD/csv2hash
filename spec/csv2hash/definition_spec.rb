require 'spec_helper'

module Csv2hash
  describe Definition do
    let(:valid_rules) { [ { position: [0,0], key: 'name' } ] }

    context 'regular context' do
      subject do
        Main.generate_definition :foo do
          set_type { Definition::MAPPING }
          mapping { cell position: [0,0], key: 'name' }
        end
      end

      it 'variable should be assigned' do
        expect(subject.type).to eql Definition::MAPPING
        expect(subject.cells.first.rules).to eql({ position: [0,0], key: 'name' })
      end
    end

    describe '#validate!' do
      context 'rules failling validation' do
        subject do
          Main.generate_definition :foo do
            set_type { :unsuitable_type }
          end
        end
        it 'should throw exception' do
          expect {
            subject.validate!
          }.to raise_error("not suitable type, please use '#{Definition::MAPPING}' " \
            "or '#{Definition::COLLECTION}'")
        end
      end

      context 'structure rules failling validation' do
        subject do
          Main.generate_definition :foo do
            set_type { Definition::MAPPING }
            set_structure_rules { :unsuitable_structure_rule }
          end
        end

        it 'should throw exception' do
          expect { subject.validate! }.to raise_error 'structure rules must be a Hash of rules'
        end
      end
    end

    describe '#default!' do
      subject do
        Main.generate_definition :foo do
          set_type { Definition::MAPPING }
          mapping { cell position: [0,0], key: 'name' }
        end
      end

      before { subject.default! }

      it 'missing key must be filled' do
        expect(subject.cells.first.rules).to eql({ position: [0, 0],
          key: 'name',
          message: 'undefined :key on :position',
          mappable: true,
          type: 'string',
          values: nil,
          case_sensitive_values: true,
          nested: nil,
          allow_blank: false,
          extra_validator: nil })
      end
    end
  end
end

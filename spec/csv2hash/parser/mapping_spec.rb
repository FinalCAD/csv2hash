require 'spec_helper'

module Csv2hash
  describe Parser::Mapping do

    let(:definition) do
      Main.generate_definition :foo do
        set_type { Definition::MAPPING }
        mapping do
          cell position: [1,1], key: 'first_name'
          cell position: [2,1], key: 'last_name'
        end
      end
    end

    let(:data_source) do
      [ ['Nickname', 'jo', nil, nil, nil],
        ['FirstName', 'John', nil, nil, nil],
        ['LastName', 'Doe', nil, nil, nil],
        [nil, nil, nil, nil, nil],
        ['Employment', 'CEO', nil, nil, nil],
        ['Post', 'Doe', nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, 'Personal info', 'Age', 26, nil],
        [nil, 'Sex', 'Male', nil, nil],
        [nil, nil, nil, nil, nil]
      ]
    end

    subject do
      Main.new(definition, data_source, ignore_blank_line: false)
    end

    context 'regular way' do
      it { expect { subject.parse! }.to_not raise_error }
      it {
        expect(subject.tap do |csv2hash|
          csv2hash.parse!
        end.data).to eql({ data: [{ 'first_name' => 'John', 'last_name' => 'Doe' }]})
      }
    end

    context 'with nested' do
      before do
        definition.cells << Cell.new({ position: [7,3], key: 'age', nested: 'infos' })
      end
      it {
        expect(subject.tap { |c| c.parse! }.data).to eql(
          { data: [ { 'first_name' => 'John', 'last_name' => 'Doe', 'infos' => { 'age' => 26 } } ] }
        )
      }
    end

    context 'discover' do
      before do
        definition.cells << Cell.new({ position: [[1,/Sex/],2], key: 'sex'})
      end
      it {
        expect(subject.tap { |c| c.parse! }.data).to eql(
          { data: [ { 'first_name' => 'John', 'last_name' => 'Doe', 'sex' => 'Male' } ] }
        )
      }
    end

    context 'discover wit fail!' do
      before do
        definition.cells << Cell.new({ position: [[1,/foo/],2], key: 'sex'})
      end
      it {
        expect { subject.tap { |c| c.parse! }}.to raise_error("Y doesn't found for [[1, /foo/], 2] on :sex")
      }
    end

    context 'discover wit fail' do
      before do
        definition.cells << Cell.new({ position: [[1,/foo/],2], key: 'sex'})
        subject.tap { |c| c.parse }
      end
      specify do
        expect(subject.errors).to_not be_empty
        expect(subject.errors).to eql(
          [{y: [1, /foo/], x: 2, message: "Y doesn't found for [[1, /foo/], 2] on :sex", key: 'sex'}])
      end
    end

  end
end

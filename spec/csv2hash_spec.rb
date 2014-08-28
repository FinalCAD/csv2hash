require 'spec_helper'

describe Csv2hash do
  let(:definition)  { double('definition', type: nil) }
  let(:data_source) { nil }

  subject do
    Csv2hash::Main.new(definition, data_source, ignore_blank_line: false)
  end

  context '...' do
    specify do
      expect(subject.options.fetch(:ignore_blank_line)).to eql(false)
    end
  end

end

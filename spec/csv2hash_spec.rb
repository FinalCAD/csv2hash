require 'spec_helper'

module Csv2hash
  describe Main do
    let(:config_file) { 'config/rules.yml' }
    let(:loader)      { YamlLoader.new(config_file).tap &:load! }
    let(:data_source) { 'config/example.csv' }

    subject do
      Main.new(loader.definition, data_source, ignore_blank_line: false)
    end

    context '...' do
      specify do
        expect(subject.options.fetch(:ignore_blank_line)).to eql(false)
      end
    end

  end
end

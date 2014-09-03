require 'spec_helper'

module Csv2hash
  describe YamlLoader do
    subject { YamlLoader.new config_file }
    before  { subject.load! }

    context 'yml' do
      let(:config_file) { 'config/rules.erb.yml' }

      specify do
        expect(subject.definition.name).to eql('example')
        expect(subject.definition.header_size).to eql(2)
      end
    end

    context 'erb' do
      let(:config_file) { 'config/rules.yml' }

      specify do
        expect(subject.definition.name).to eql('example')
        expect(subject.definition.header_size).to eql(2)
      end
    end

  end
end

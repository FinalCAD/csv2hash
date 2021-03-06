require 'spec_helper'

module Csv2hash
  describe YamlLoader do
    subject { YamlLoader.new config_file }
    before  { subject.load! }

    context 'yml' do
      let(:config_file) { 'config/rules.yml.erb' }

      specify do
        expect(subject.definition.name).to eql('example')
        expect(subject.definition.header_size).to eql(2)
        expect(subject.definition.cells.last.rules.fetch(:values)).to eql(18..90)
      end
    end

    context 'erb' do
      let(:config_file) { 'config/rules.yml' }

      specify do
        expect(subject.definition.name).to eql('example')
        expect(subject.definition.header_size).to eql(2)
      end
    end

    context 'extra validator' do
      let(:config_file) { 'config/rules.extra_validator.yml.erb' }

      specify do
        expect(subject.definition.name).to eql('example')
        expect(subject.definition.header_size).to eql(0)
        expect(subject.definition.cells.first.rules.fetch(:extra_validator)).to be_a(DowncaseValidator)
        expect(subject.definition.cells.last.rules.fetch(:position)[0][1]).to eql(/LastName/)
      end
    end

  end
end

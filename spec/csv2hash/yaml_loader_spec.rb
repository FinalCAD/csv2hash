require 'spec_helper'

module Csv2hash
  describe YamlLoader do
    let(:config_file) { 'config/rules.yml' }

    subject do
      YamlLoader.new config_file
    end

    before do
      subject.load!
    end

    specify do
      expect(subject.definition.name).to eql('example')
    end

  end
end

require 'spec_helper'

module Csv2hash
  module Coercers
    describe YamlCoercer do
      context 'when position is a string' do 
        let(:rules) { {:position=>"Mobile phone number", :key=>"mobile_phone", :allow_blank=>true} }
        let(:result_rules) { {:position=>/\A(Mobile phone number)\z/, :key=>"mobile_phone", :allow_blank=>true} }
        subject { YamlCoercer.new(rules) }

        before { subject.deserialize! }
   
        it{expect(subject.rules).to eql(result_rules)}
      end 

      context 'when position is a array' do 
        let(:rules) { {:position=>[[1,"Mobile phone number"],2], :key=>"mobile_phone", :allow_blank=>true} }
        let(:result_rules) { {:position=>[[1, /Mobile phone number/], 2], :key=>"mobile_phone", :allow_blank=>true} }
        subject { YamlCoercer.new(rules) }

        before { subject.deserialize! }
   
        it{expect(subject.rules).to eql(result_rules)}
      end 
    end
  end
end

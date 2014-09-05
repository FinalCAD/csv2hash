require 'spec_helper'

module Csv2hash
  describe TypeCoercer do
    let(:data) do
      { foo: ' y   ', bar: 'no', zone: ' Null', mischievous: ' pronoun ' }
    end
    let(:coercer) { TypeCoercer.new(data) }

    before { coercer.deserialize! }

    specify do
      expect(coercer.data).to eql({ foo: true, bar: false, zone: nil, mischievous: ' pronoun ' })
    end
  end
end

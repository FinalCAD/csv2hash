require_relative '../../../lib/csv2hash/extra_validator'

module Csv2Hash
  class DowncaseValidator < ExtraValidator
    def valid? rule, value
      !!(value.match /^[a-z]+$/)
    end
  end
end

require 'csv2hash'
require 'bundler/setup'
require 'coveralls'
require 'its'

Coveralls.wear!

RSpec.configure do |c|
  c.run_all_when_everything_filtered = true
end

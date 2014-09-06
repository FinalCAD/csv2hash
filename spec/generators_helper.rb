require 'csv2hash'
require 'bundler/setup'

# require 'rails'

module TestApp
  class Application < ::Rails::Application
    config.root = File.dirname(__FILE__)
  end
end

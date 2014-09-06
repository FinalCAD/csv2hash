# require 'generators_helper'
#
# # Generators are not automatically loaded by Rails
# require 'generators/csv2hash/install_generator'
#
# describe Csv2hash::Generators::InstallGenerator do
#   # Tell the generator where to put its output (what it thinks of as Rails.root)
#   destination File.expand_path('../../../tmp', __FILE__)
#   teardown :cleanup_destination_root
#
#   before {
#     prepare_destination
#   }
#
#   def cleanup_destination_root
#     FileUtils.rm_rf destination_root
#   end
#
#   describe '...' do
#     before { run_generator }
#
#     describe 'config/initializers/csv2hash.rb' do
#       subject { file('config/initializers/csv2hash.rb') }
#       it { should exist }
#       it { should contain "Csv2hash.configure do |config|"}
#       # it { should contain "# conf.convert = false" }
#       # it { should contain "# conf.true_values  = ['yes','y','t']" }
#       # it { should contain "# conf.false_values = ['no','n','f']" }
#       # it { should contain "# conf.nil_values   = ['nil','null']" }
#     end
#   end
# end

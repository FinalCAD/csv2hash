require 'rails/generators'
require 'generator_spec'

# Generators are not automatically loaded by Rails
require_relative '../../../../lib/generators/csv2hash/install/install_generator'

module Csv2hash
  module Generators
    describe InstallGenerator do
      # Tell the generator where to put its output (what it thinks of as Rails.root)
      destination File.expand_path('../../../../tmp', __FILE__)

      before do
        prepare_destination
        run_generator
      end

      after do
        FileUtils.rm_rf destination_root
      end

      specify do
        expect(destination_root).to have_structure do
          no_file 'csv2hash.rb'
          directory 'config' do
            directory 'initializers' do
              file 'csv2hash.rb' do
                contains 'Csv2hash.configure'
              end
            end
          end
        end
      end
    end
  end
end
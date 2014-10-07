module Csv2hash
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc <<DESC
description :
    copy csv2hash configuration to an initializer.
DESC
      def create_configuration
        template 'csh2hash.rb', 'config/initializers/csh2hash.rb'
      end
    end
  end
end

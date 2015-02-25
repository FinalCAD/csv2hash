require_relative 'abstract'

require 'csv'

module Csv2hash
  module Adapter
    class CsvAdapter < Abstract

      attr_accessor :file_path

      def initialize file_path
        self.file_path = file_path
      end

      def source
        check_file!
        CSV.read self.file_path
      end

      private

      def check_file!
        raise ::Csv2hash::InvalidFile unless File.extname(self.file_path) =~ /csv/i
      end

    end
  end
end

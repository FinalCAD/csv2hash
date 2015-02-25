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
        CSV.read self.file_path
      rescue ::ArgumentError
        raise ::Csv2hash::InvalidFile
      end

    end
  end
end

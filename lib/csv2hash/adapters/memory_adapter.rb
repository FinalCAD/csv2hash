require_relative 'abstract'

module Csv2hash
  module Adapter
    class MemoryAdapter < Abstract

      attr_accessor :data

      def initialize data
        self.data = data
      end

      def source
        self.data
      end

    end
  end
end

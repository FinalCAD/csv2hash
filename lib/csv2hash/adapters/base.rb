module Csv2hash
  module Adapter
    class Base

      class UnsupportedAdapter < StandardError ; end

      def self.create adapter_name, file_path_or_data
        load "csv2hash/adapters/#{adapter_name}_adapter.rb"
        class_eval("Csv2hash::Adapter::#{klass_adapter(adapter_name)}").new file_path_or_data
      end

      private

      def self.klass_adapter adapter_symbol
        case adapter_symbol
        when :memory then :MemoryAdapter
        when :csv then :CsvAdapter
        else raise UnsupportedAdapter.new
        end
      end

    end
  end
end

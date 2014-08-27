module Csv2hash
  module Adapter
    class Abstract

      def source
        raise NotImplementedError
      end

    end
  end
end

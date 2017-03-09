module Awis
  module Utils
    module Extra
      def camelize(string)
        string.split("_").map { |w| w.capitalize }.join
      end

      module_function :camelize
    end
  end
end

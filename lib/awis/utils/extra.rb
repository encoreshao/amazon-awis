# frozen_string_literal: true

module Awis
  module Utils
    module Extra
      def camelize(string)
        string.split('_').map(&:capitalize).join
      end

      module_function :camelize
    end
  end
end

# frozen_string_literal: true

module Awis
  module Utils
    module Variable
      def custom_instance_variables(options)
        options.each do |key, value|
          value = value.class == String && value.empty? ? nil : value

          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end

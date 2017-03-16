module Awis
  module Models
    class BaseEntity
      include Utils::Variable

      def initialize(options)
        custom_instance_variables(options)
      end
    end
  end
end

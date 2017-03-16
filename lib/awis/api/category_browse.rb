module Awis
  module API
    class CategoryBrowse < Base
      DEFAULT_RESPONSE_GROUP = %w(categories related_categories language_categories letter_bars).freeze

      def load_request_uri(arguments = {})
        validation_arguments!(arguments)

        super(params)
      end

      private
      def before_validation_arguments(arguments)
        raise ArgumentError, "Invalid arguments. should be like { path: 'Top/Arts' }" unless arguments.is_a?(Hash)
        raise ArgumentError, "Invalid arguments. the path must be configured." unless arguments.has_key?(:path)
      end

      def validation_arguments!(arguments)
        before_validation_arguments(arguments)

        @arguments = arguments
        @arguments[:response_group] = Array(arguments.fetch(:response_group, DEFAULT_RESPONSE_GROUP))
        @arguments[:descriptions]   = arguments.fetch(:descriptions, true)
      end

      def params
        {
          "Action"        => action_name,
          "ResponseGroup" => response_groups,
          "Path"          => arguments[:path],
          "Descriptions"  => request_description_params
        }
      end

      def response_groups
        arguments[:response_group].sort.map { |group| camelize(group) }.join(",")
      end
    end
  end
end

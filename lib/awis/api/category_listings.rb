module Awis
  module API
    class CategoryListings < Base
      DEFAULT_RESPONSE_GROUP = %w(listings).freeze

      def load_request_uri(arguments = {})
        validation_arguments!(arguments)

        super(params)
      end

      private
      def before_validation_arguments(arguments)
        raise ArgumentError, "Invalid arguments. should be like { path: '/Top/Games/Card_Games' }" unless arguments.is_a?(Hash)
        raise ArgumentError, "Invalid arguments. the path must be configured." unless arguments.has_key?(:path)
      end

      def validation_arguments!(arguments)
        before_validation_arguments(arguments)

        @arguments = arguments
        @arguments[:sort_by]      = arguments.fetch(:sort_by, "popularity")
        @arguments[:recursive]    = arguments.fetch(:recursive, true)
        @arguments[:descriptions] = arguments.fetch(:descriptions, true)
        @arguments[:start]        = arguments.fetch(:start, 0)
        @arguments[:count]        = arguments.fetch(:count, 20)
      end

      def params
        {
          "Action"        => "CategoryListings",
          "ResponseGroup" => DEFAULT_RESPONSE_GROUP[0],
          "Path"          => arguments[:path],
          "Recursive"     => recursive_param,
          "Descriptions"  => descriptions_params,
          "SortBy"        => sort_by_param,
          "Count"         => arguments[:count],
          "Start"         => arguments[:start],
        }
      end

      def recursive_param
        arguments[:recursive].to_s.capitalize
      end

      def descriptions_params
        arguments[:descriptions].to_s.capitalize
      end

      def sort_by_param
        camelize(arguments[:sort_by])
      end
    end
  end
end

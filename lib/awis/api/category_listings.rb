module Awis
  module API
    class CategoryListings < Base
      def fetch(arguments = {})
        raise ArgumentError, "You must provide a URL" unless arguments.has_key?(:path)
        validation_arguments!(arguments)
        
        @response_body = Awis::Connection.new.get(params)
        self
      end

      def load_request_uri(arguments = {})
        validation_arguments!(arguments)

        super(params)
      end

      private
      def validation_arguments!(arguments)
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
          "ResponseGroup" => "Listings",
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

module Awis
  module API
    class TrafficHistory < Base
      def load_request_uri(arguments = {})
        validation_arguments!(arguments)

        super(params)
      end

      private
      def params
        {
          "Action"        => "TrafficHistory",
          "Url"           => arguments[:url],
          "ResponseGroup" => "History",
          "Range"         => arguments[:range],
          "Start"         => start_param,
        }
      end

      def validation_arguments!(arguments)
        before_validation_arguments(arguments)

        @arguments = arguments
        @arguments[:range] = arguments.fetch(:range, 31)
        @arguments[:start] = arguments.fetch(:start) { Time.now - (3600 * 24 * @arguments[:range].to_i) }
      end

      def start_param
        arguments[:start].respond_to?(:strftime) ? arguments[:start].strftime("%Y%m%d") : arguments[:start]
      end
    end
  end
end

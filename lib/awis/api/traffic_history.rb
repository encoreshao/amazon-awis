module Awis
  module API
    class TrafficHistory < Base
      def fetch(arguments = {})
        raise ArgumentError, "Any valid URL." unless arguments.has_key?(:url)

        validation_arguments!(arguments)
        @response_body = Awis::Connection.new.get(params)
        self
      end

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

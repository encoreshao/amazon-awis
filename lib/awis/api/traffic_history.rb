module Awis
  module API
    class TrafficHistory < Base
      def fetch(arguments = {})
        raise ArgumentError, "Any valid URL." unless arguments.has_key?(:url)
        @arguments = arguments

        @arguments[:range] = arguments.fetch(:range, 31)
        @arguments[:start] = arguments.fetch(:start) { Time.now - (3600 * 24 * @arguments[:range].to_i) }

        @response_body = Awis::Connection.new.get(params)
        self
      end

      def params
        {
          "Action"        => "TrafficHistory",
          "Url"           => arguments[:url],
          "ResponseGroup" => "History",
          "Range"         => arguments[:range],
          "Start"         => start_param,
        }
      end

      def start_param
        arguments[:start].respond_to?(:strftime) ? arguments[:start].strftime("%Y%m%d") : arguments[:start]
      end
    end
  end
end

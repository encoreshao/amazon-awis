module Awis
  module API
    class TrafficHistory < Base
      DEFAULT_RESPONSE_GROUP = %w(history).freeze

      def load_request_uri(arguments = {})
        validation_arguments!(arguments)

        super(params)
      end

      private
      def params
        {
          "Action"        => action_name,
          "Url"           => arguments[:url],
          "ResponseGroup" => response_groups,
          "Range"         => arguments[:range],
          "Start"         => start_date,
        }
      end

      def validation_arguments!(arguments)
        before_validation_arguments(arguments)

        @arguments = arguments
        @arguments[:range] = arguments.fetch(:range, 31)
        @arguments[:start] = arguments.fetch(:start) { Time.now - (3600 * 24 * @arguments[:range].to_i) }
      end

      def start_date
        arguments[:start].respond_to?(:strftime) ? arguments[:start].strftime("%Y%m%d") : arguments[:start]
      end

      def response_groups
        DEFAULT_RESPONSE_GROUP.map { |group| camelize(group) }.join(",")
      end
    end
  end
end

module Awis
  module API
    class SitesLinkingIn < Base
      DEFAULT_RESPONSE_GROUP = %w(sites_linking_in).freeze

      def load_request_uri(arguments = {})
        validation_arguments!(arguments)

        super(params)
      end

      private
      def validation_arguments!(arguments)
        before_validation_arguments(arguments)

        @arguments = arguments
        @arguments[:count] = arguments.fetch(:count, 20)
        @arguments[:start] = arguments.fetch(:start, 0)
      end

      def params
        {
          "Action"        => "SitesLinkingIn",
          "Url"           => arguments[:url],
          "ResponseGroup" => DEFAULT_RESPONSE_GROUP[0],
          "Count"         => arguments[:count],
          "Start"         => arguments[:start]
        }
      end
    end
  end
end

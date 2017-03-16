module Awis
  module API
    class SitesLinkingIn < Base
      attr_accessor :sites

      def fetch(arguments = {})
        raise ArgumentError, "You must provide a URL" unless arguments.has_key?(:url)
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
        @arguments[:count] = arguments.fetch(:count, 20)
        @arguments[:start] = arguments.fetch(:start, 0)
      end

      def params
        {
          "Action"        => "SitesLinkingIn",
          "Url"           => arguments[:url],
          "ResponseGroup" => "SitesLinkingIn",
          "Count"         => arguments[:count],
          "Start"         => arguments[:start]
        }
      end
    end
  end
end

module Awis
  module API
    class SitesLinkingIn < Base
      attr_accessor :sites

      def fetch(arguments = {})
        raise ArgumentError, "You must provide a URL" unless arguments.has_key?(:url)

        @arguments = arguments
        @arguments[:count] = arguments.fetch(:count, 20)
        @arguments[:start] = arguments.fetch(:start, 0)

        @response_body = Awis::Connection.new.get(params)
        self
      end

      private
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

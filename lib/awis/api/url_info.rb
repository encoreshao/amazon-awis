module Awis
  module API
    class UrlInfo < Base
      DEFAULT_RESPONSE_GROUP = %w(related_links categories rank rank_by_country usage_stats adult_content speed language owned_domains links_in_count site_data).freeze

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
      def validation_arguments!(arguments)
        @arguments = arguments
        @arguments[:response_group] = Array(arguments.fetch(:response_group, DEFAULT_RESPONSE_GROUP))
      end

      def params
        {
          "Action"        => action_name,
          "Url"           => arguments[:url],
          "ResponseGroup" => response_groups,
        }
      end

      def response_groups
        arguments[:response_group].sort.map { |group| camelize(group) }.join(",")
      end
    end
  end
end

# frozen_string_literal: true

module Awis
  module API
    class SitesLinkingIn < Base
      DEFAULT_RESPONSE_GROUP = %w[sites_linking_in].freeze

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
          'Action'        => action_name,
          'Url'           => arguments[:url],
          'ResponseGroup' => response_groups,
          'Count'         => arguments[:count],
          'Start'         => arguments[:start]
        }
      end

      def response_groups
        DEFAULT_RESPONSE_GROUP.map { |group| camelize(group) }.join(',')
      end
    end
  end
end

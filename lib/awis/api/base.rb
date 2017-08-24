module Awis
  module API
    class Base
      include Utils::Extra
      attr_reader :arguments, :response_body

      def fetch(arguments = {})
        validation_arguments!(arguments)

        loading_response_body
        self
      end

      def request_description_params
        arguments[:descriptions].to_s.capitalize
      end

      def parsed_body
        @parsed_body ||= MultiXml.parse(response_body)
      end

      def loading_response_body
        @response_body = Awis::Connection.new.get(params)
      end

      def root_node_name
        "#{action_name}Response"
      end

      def action_name
        self.class.name.split(/\:\:/)[-1]
      end

      def load_request_uri(params)
        collection = Awis::Connection.new
        collection.setup_params(params)
        collection.request_url
      end

      def before_validation_arguments(arguments)
        raise ArgumentError, "Invalid arguments. should be like { url: 'site.com' }" unless arguments.is_a?(Hash)
        raise ArgumentError, "Invalid arguments. the url must be configured." unless arguments.has_key?(:url)
      end

      class << self
        def loading_data_from_xml(xml_file_path)
          MultiXml.parse(File.new(xml_file_path))
        end
      end
    end
  end
end

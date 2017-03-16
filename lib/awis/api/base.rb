module Awis
  module API
    class Base
      include Utils::Extra
      attr_reader :arguments, :response_body

      def parsed_body
        @parsed_body ||= MultiXml.parse(response_body)
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
        collection.uri
      end

      class << self
        def loading_data_from_xml(xml_file_path)
          MultiXml.parse(File.new(xml_file_path))
        end
      end
    end
  end
end

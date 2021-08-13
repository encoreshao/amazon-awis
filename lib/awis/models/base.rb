# frozen_string_literal: true

module Awis
  module Models
    class Base
      attr_accessor :response, :status_code, :request_id

      def initialize(response)
        response_data = loading_response(response)

        set_xml(response_data)
        # Need to implement on sub-class
        setup_data!(response_data)
      end

      def loading_response(response)
        Awis::Utils::XML.new(response.response_body)
      end

      def root_node_name
        "/aws:#{action_name}Response/aws:Response/aws:#{action_name}Result/aws:Alexa"
      end

      def action_name
        self.class.name.split(/\:\:/)[-1]
      end

      def relationship_collections(item_object, items, items_count, kclass)
        return if items.empty?

        all_items = {}.array_slice_merge!(:item, items, items_count)
        all_items.map { |item| item_object << kclass.new(item) }
      end

      def success?
        status_code == 'Success'
      end

      def pretty_xml
        doc = Nokogiri.XML(@xml.data) do |config|
          config.default_xml.noblanks
        end
        puts doc.to_xml(:indent => 2)

        nil
      end

      private

      def set_xml(response)
        @xml = response
      end
    end
  end
end

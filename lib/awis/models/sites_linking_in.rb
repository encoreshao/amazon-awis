module Awis
  module Models
    class SitesLinkingIn < Base
      attr_accessor :sites

      def initialize(response)
        @sites = []
        setup_data!( loading_response(response) )
      end

      def setup_data!(response)
        sites = []

        response.each_node do |node, path|
          text = node.inner_xml

          if node.name == 'aws:RequestId'
            @request_id ||= text
          elsif node.name == 'aws:StatusCode'
            @status_code ||= text
          elsif node.name == 'aws:Title'
            sites << { title: text }
          elsif node.name == 'aws:Url'
            sites << { url: text }
          end
        end

        relationship_collections(@sites, sites, 2, Site)
      end
    end

    class Site
      attr_accessor :title, :url
      
      def initialize(hash)
        hash.map { |k, v| instance_variable_set("@#{k}", v) }
      end
    end
  end
end

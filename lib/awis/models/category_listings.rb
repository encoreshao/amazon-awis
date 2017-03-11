module Awis
  module Models
    class CategoryListings < Base
      attr_accessor :count, :recursive_count, :listings

      def initialize(response)
        @listings = []
        setup_data!( loading_response(response) )
      end

      def setup_data!(response)
        category_listings = []

        response.each_node do |node, path|
          text = node.inner_xml
          text = text.to_i if text.to_i.to_s === text

          if node.name == 'aws:RequestId'
            @request_id ||= text
          elsif node.name == 'aws:StatusCode'
            @status_code ||= text
          elsif node.name == 'aws:Count'
            @count ||= text
          elsif node.name == 'aws:RecursiveCount'
            @recursive_count ||= text
          elsif node.name == 'aws:DataUrl' && path == "#{base_node_name}/aws:DataUrl"
            category_listings << { data_url: text }
          elsif node.name == 'aws:Title' && path == "#{base_node_name}/aws:Title"
            category_listings << { title: text }
          elsif node.name == 'aws:PopularityRank' && path == "#{base_node_name}/aws:PopularityRank"
            category_listings << { popularity_rank: text }
          elsif node.name == 'aws:Description' && path == "#{base_node_name}/aws:Description"
            category_listings << { description: text }
          end
        end

        relationship_collections(@listings, category_listings, 4, Listing)
      end

      def base_node_name
        "#{root_node_name}/aws:CategoryListings/aws:Listings/aws:Listing"
      end
    end

    class Listing
      attr_accessor :data_url, :title, :popularity_rank, :description

      def initialize(options)
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end

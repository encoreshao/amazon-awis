module Awis
  module Models
    class CategoryBrowse < Base
      attr_accessor :categories, :language_categories, :related_categories, :letter_bars

      def initialize(response)
        @categories = []
        @language_categories = []
        @related_categories = []
        @letter_bars = []
        
        setup_data! loading_response(response)
      end

      def setup_data!(response)
        categories = []
        language_categories = []
        related_categories = []
        letter_bars = []

        response.each_node do |node, path|
          text = node.inner_xml
          text = text.to_i if text.to_i.to_s === text
          text = nil if (text.class == String && text.empty?)

          if node.name == 'aws:RequestId'
            @request_id ||= text
          elsif node.name == 'aws:StatusCode'
            @status_code ||= text
          elsif node.name == 'aws:Path' && path == "#{category_node_name}/aws:Path"
            categories << { path: text }
          elsif node.name == 'aws:Title' && path == "#{category_node_name}/aws:Title"
            categories << { title: text }
          elsif node.name == 'aws:SubCategoryCount' && path == "#{category_node_name}/aws:SubCategoryCount"
            categories << { sub_category_count: text }
          elsif node.name == 'aws:TotalListingCount' && path == "#{category_node_name}/aws:TotalListingCount"
            categories << { total_listing_count: text }
          elsif node.name == 'aws:Path' && path == "#{language_category_node_name}/aws:Path"
            language_categories << { path: text }
          elsif node.name == 'aws:Title' && path == "#{language_category_node_name}/aws:Title"
            language_categories << { title: text }
          elsif node.name == 'aws:SubCategoryCount' && path == "#{language_category_node_name}/aws:SubCategoryCount"
            language_categories << { sub_category_count: text }
          elsif node.name == 'aws:TotalListingCount' && path == "#{language_category_node_name}/aws:TotalListingCount"
            language_categories << { total_listing_count: text }
          elsif node.name == 'aws:Path' && path == "#{related_category_node_name}/aws:Path"
            related_categories << { path: text }
          elsif node.name == 'aws:Title' && path == "#{related_category_node_name}/aws:Title"
            related_categories << { title: text }
          elsif node.name == 'aws:SubCategoryCount' && path == "#{related_category_node_name}/aws:SubCategoryCount"
            related_categories << { sub_category_count: text }
          elsif node.name == 'aws:TotalListingCount' && path == "#{related_category_node_name}/aws:TotalListingCount"
            related_categories << { total_listing_count: text }
          elsif node.name == 'aws:Path' && path == "#{letter_bars_node_name}/aws:Path"
            letter_bars << { path: text }
          elsif node.name == 'aws:Title' && path == "#{letter_bars_node_name}/aws:Title"
            letter_bars << { title: text }
          elsif node.name == 'aws:SubCategoryCount' && path == "#{letter_bars_node_name}/aws:SubCategoryCount"
            letter_bars << { sub_category_count: text }
          elsif node.name == 'aws:TotalListingCount' && path == "#{letter_bars_node_name}/aws:TotalListingCount"
            letter_bars << { total_listing_count: text }
          end
        end

        relationship_collections(@categories, categories, 4, Category)
        relationship_collections(@language_categories, language_categories, 4, LanguageCategory)
        relationship_collections(@related_categories, related_categories, 4, RelatedCategory)
        relationship_collections(@letter_bars, letter_bars, 4, LetterBar)
      end

      def base_node_name
        "#{root_node_name}/aws:CategoryBrowse"
      end

      def category_node_name
        "#{base_node_name}/aws:Categories/aws:Category"
      end

      def language_category_node_name
        "#{base_node_name}/aws:LanguageCategories/aws:Category"
      end

      def related_category_node_name
        "#{base_node_name}/aws:RelatedCategories/aws:Category"
      end

      def letter_bars_node_name
        "#{base_node_name}/aws:LetterBars/aws:Category"
      end
    end

    class Category < BaseEntity
      attr_accessor :path, :title, :sub_category_count, :total_listing_count
    end

    class LanguageCategory < BaseEntity
      attr_accessor :path, :title, :sub_category_count, :total_listing_count
    end

    class RelatedCategory < BaseEntity
      attr_accessor :path, :title, :sub_category_count, :total_listing_count
    end

    class LetterBar < BaseEntity
      attr_accessor :path, :title, :sub_category_count, :total_listing_count
    end
  end
end

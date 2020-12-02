# frozen_string_literal: true

require_relative './models/base'
require_relative './models/base_entity'
require_relative './models/url_info'
require_relative './models/traffic_history'
require_relative './models/sites_linking_in'
require_relative './models/category_listings'
require_relative './models/category_browse'

module Awis
  module Models
    autoload :Base,             'awis/models/base'
    autoload :BaseEntity,       'awis/models/base_entity'
    autoload :UrlInfo,          'awis/models/url_info'
    autoload :TrafficHistory,   'awis/models/traffic_history'
    autoload :SitesLinkingIn,   'awis/models/sites_linking_in'
    autoload :CategoryListings, 'awis/models/category_listings'
    autoload :CategoryBrowse,   'awis/models/category_browse'
  end
end

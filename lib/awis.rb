require "multi_xml"
require "nokogiri"

require "awis/version"
require "awis/hash"
require "awis/utils/xml"
require "awis/utils/extra"
require "awis/utils/variable"
require "awis/exceptions"
require "awis/connection"
require "awis/config"
require "awis/client"
require "awis/api"
require "awis/models"

module Awis
  API_VERSION           = "2005-07-11".freeze
  API_HOST              = "awis.amazonaws.com".freeze
  API_SIGNATURE_VERSION = "2".freeze

  class << self
  end
end

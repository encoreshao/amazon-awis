require "multi_xml"
require "nokogiri"

require "awis/version"
require "awis/hash"
require "awis/utils/xml"
require "awis/utils/extra"
require "awis/utils/variable"
require "awis/utils/request"
require "awis/exceptions"
require "awis/connection"
require "awis/config"
require "awis/client"
require "awis/api"
require "awis/models"

module Awis
  SERVICE_HOST          = "awis.amazonaws.com".freeze
  SERVICE_ENDPOINT      = "awis.us-west-1.amazonaws.com".freeze
  SERVICE_PORT          = 443
  SERVICE_URI           = "/api".freeze
  SERVICE_REGION        = "us-west-1".freeze
  SERVICE_NAME          = "awis".freeze

  class << self
  end
end

require "multi_xml"
require "nokogiri"
require "aws-sigv4"

require "awis/version"
require "awis/hash"
require "awis/utils"
require "awis/exceptions"
require "awis/connection"
require "awis/config"
require "awis/client"
require "awis/api"
require "awis/models"

module Awis
  SERVICE_PATH          = "api".freeze
  SERVICE_NAME          = "awis".freeze
  SERVICE_REGION        = "us-west-1".freeze
  SERVICE_HOST          = "#{SERVICE_NAME}.amazonaws.com"
end

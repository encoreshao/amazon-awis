# frozen_string_literal: true

require 'multi_xml'
require 'nokogiri'
require 'aws-sigv4'

require_relative './awis/version'
require_relative './awis/hash'
require_relative './awis/utils'
require_relative './awis/exceptions'
require_relative './awis/connection'
require_relative './awis/config'
require_relative './awis/client'
require_relative './awis/api'
require_relative './awis/models'

module Awis
  SERVICE_PATH          = 'api'
  SERVICE_NAME          = 'awis'
  SERVICE_REGION        = 'us-west-1'
  SERVICE_HOST          = "#{SERVICE_NAME}.#{SERVICE_REGION}.amazonaws.com"
end

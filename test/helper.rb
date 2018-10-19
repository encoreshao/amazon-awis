# frozen_string_literal: true

require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/setup'
require 'byebug'
require 'pry'
require 'pry-byebug'
require 'awis'

class MiniTest::Test
  def setup
    WebMock.disable_net_connect!
  end

  # Recording response is as simple as writing in terminal:
  #   curl -is -X GET "https://awis.amazonaws.com/api/?Action=UrlInfo&AWSAccessKeyId=fake" > response.txt
  def fixture(filename)
    File.read(File.join('test', 'fixtures', filename))
  end

  def api_url
    %r{#{Awis::SERVICE_HOST}}
  end
end

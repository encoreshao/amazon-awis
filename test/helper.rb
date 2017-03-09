require "minitest/autorun"
require "webmock/minitest"
require "mocha/setup"
require "awis"
require 'nokogiri'

class MiniTest::Test
  def setup
    WebMock.disable_net_connect!
  end

  # Recording response is as simple as writing in terminal:
  #   curl -is -X GET "http://awis.amazonaws.com/?Action=UrlInfo&AWSAccessKeyId=fake" > response.txt
  def fixture(filename)
    File.read(File.join("test", "fixtures", filename))
  end
end

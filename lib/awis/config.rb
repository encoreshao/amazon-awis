require "singleton"

module Awis
  class Config
    include Singleton
    attr_accessor :access_key_id, :secret_access_key, :proxy, :debug, :protocol,
                  :timeout, :open_timeout, :logger
  end

  def self.config
    yield Config.instance if block_given?

    Config.instance
  end
end

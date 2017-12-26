module Awis
  class Connection
    include Awis::Utils::Request

    attr_accessor :debug, :protocol
    attr_writer :params

    def initialize
      raise CertificateError.new("Amazon access certificate is missing!") if Awis.config.access_key_id.nil? || Awis.config.secret_access_key.nil?

      setup_options!
    end

    def setup_options!
      @debug        = Awis.config.debug || false
      @protocol     = Awis.config.protocol || 'https'
      @timeout      = Awis.config.timeout || 10
      @open_timeout = Awis.config.open_timeout || 10
    end

    def params
      @params ||= {}
    end

    def setup_params(params)
      self.params = params
    end

    def get(params = {})
      setup_params(params)

      response = handle_response(request)
      response.body.force_encoding(Encoding::UTF_8)
    end
  end
end

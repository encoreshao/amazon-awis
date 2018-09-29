require "cgi"
require "aws-sigv4"
require "net/https"

module Awis
  class Connection
    attr_accessor :debug, :protocol
    attr_reader :params, :secret_access_key, :access_key_id

    HEADERS = {
        "Content-Type" => "application/xml",
        "Accept" => "application/xml",
        "User-Agent" => "awis-sdk-ruby v#{Awis::VERSION}"
    }.freeze

    def initialize(options = {})
      @secret_access_key = options.fetch(:secret_access_key, Awis.config.access_key_id)
      @access_key_id     = options.fetch(:access_key_id, Awis.config.secret_access_key)
      raise CertificateError.new("Amazon access certificate is missing!") if @secret_access_key.nil? || @access_key_id.nil?

      setup_options!
    end

    def setup_options!
      @debug        = Awis.config.debug || false
      @protocol     = Awis.config.protocol || 'https'
      @timeout      = Awis.config.timeout || 10
      @open_timeout = Awis.config.open_timeout || 10
    end

    def get(params = {})
      @params = params
      handle_response(request).body.force_encoding(Encoding::UTF_8)
    end

    private

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        response
      else
        handle_error_response(response)
      end
    end

    def handle_error_response(response)
      case response.code.to_i
      when 300...600
        if response.body.nil?
          raise ResponseError.new(nil, response)
        else
          error_message = MultiXml.parse(response.body).deep_find('ErrorCode')
          raise ResponseError.new(error_message, response)
        end
      else
        raise ResponseError.new("Unknown code: #{response.code}", response)
      end
    end

    def request
      req = Net::HTTP::Get.new(uri)
      headers.each do |key, value|
        req[key] = value
      end
      Net::HTTP.start(
          uri.hostname,
          uri.port,
          use_ssl: uri.scheme == 'https',
          ssl_timeout: @timeout,
          open_timeout: @open_timeout
      ) do |http|
        http.request(req)
      end
    end

    def uri
      @uri ||= URI.parse("#{protocol}://#{Awis::SERVICE_HOST}/#{Awis::SERVICE_PATH}?" << query)
    end

    def headers
      HEADERS.merge(auth_headers)
    end

    def auth_headers
      signer.sign_request(
          http_method: "GET",
          headers: HEADERS,
          url: uri.to_s
      ).headers
    end

    def signer
      Aws::Sigv4::Signer.new(
          service: Awis::SERVICE_NAME,
          region: Awis::SERVICE_REGION,
          access_key_id: access_key_id,
          secret_access_key: secret_access_key
      )
    end

    def query
      params.map do |key, value|
        "#{key}=#{CGI.escape(value.to_s)}"
      end.sort!.join("&")
    end
  end
end

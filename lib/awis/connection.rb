require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "faraday"
require "time"

module Awis
  class Connection
    attr_accessor :debug, :protocol
    attr_writer :params

    def initialize
      raise CertificateError.new("Amazon access certificate is missing!") if Awis.config.access_key_id.nil? || Awis.config.secret_access_key.nil?

      setup_options!
    end

    def setup_options!
      @debug        = Awis.config.debug || false
      @protocol     = Awis.config.protocol || 'https'
      @timeout      = Awis.config.timeout || 5
      @open_timeout = Awis.config.open_timeout || 2
    end

    def params
      @params ||= {}
    end

    def setup_params(params)
      self.params = params
    end

    def get(params = {})
      setup_params(params)

      handle_response(request).body.force_encoding(Encoding::UTF_8)
    end

    def handle_response(response)
      case response.status.to_i
      when 200...300
        response
      when 300...600
        if response.body.nil?
          raise ResponseError.new(nil, response)
        else
          xml = MultiXml.parse(response.body)
          message = xml["Response"]["Errors"]["Error"]["Message"]
          raise ResponseError.new(message, response)
        end
      else
        raise ResponseError.new("Unknown code: #{respnse.code}", response)
      end
    end

    def request
      connection = Faraday.new(url: host_with_port) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger do |logger|
          logger.filter(/(AWSAccessKeyId=)(\w+)/, '\1[REMOVED]')
        end if Awis.config.logger
        faraday.adapter  :net_http
      end

      connection.get do |req|
        req.url url_params
        req.options.open_timeout = @timeout
        req.options.timeout = @open_timeout
      end
    end

    def host_with_port
      protocol + '://' + Awis::API_HOST
    end

    def timestamp
      @timestamp ||= Time::now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), Awis.config.secret_access_key, sign)).strip
    end

    def url_params
      '?' + original_params
    end

    def request_url
      URI.parse(host_with_port + url_params)
    end

    def default_params
      {
        "AWSAccessKeyId"   => Awis.config.access_key_id,
        "SignatureMethod"  => "HmacSHA256",
        "SignatureVersion" => Awis::API_SIGNATURE_VERSION,
        "Timestamp"        => timestamp,
        "Version"          => Awis::API_VERSION
      }
    end

    def sign
      "GET\n" + Awis::API_HOST + "\n/\n" + query_params
    end

    def query_params
      default_params.merge(params).map { |key, value| "#{key}=#{CGI::escape(value.to_s)}" }.sort.join("&")
    end

    def original_params
      query_params + "&Signature=" + CGI::escape(signature)
    end
  end
end

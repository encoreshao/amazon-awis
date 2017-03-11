require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "faraday"
require "time"

module Awis
  class Connection
    attr_accessor :debug
    attr_writer :params

    def initialize
      raise CertificateError.new("Amazon access certificate is missing!") if Awis.config.access_key_id.nil? || Awis.config.secret_access_key.nil?

      @debug = Awis.config.debug || false
    end

    def params
      @params ||= {}
    end

    def get(params = {})
      self.params = params

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
      showing_request_uri
      
      Faraday.get(uri)
    end

    def showing_request_uri
      puts "[DEBUG] -> #{uri}" if debug
    end

    def timestamp
      @timestamp ||= Time::now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), Awis.config.secret_access_key, sign)).strip
    end

    def uri
      URI.parse("http://#{Awis::API_HOST}/?" + query_params + "&Signature=" + CGI::escape(signature))
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
  end
end

# frozen_string_literal: true

module Awis
  # Awis exceptions can be caught by rescuing: Awis::StandardError

  class StandardError < StandardError; end
  class ArgumentError < StandardError; end
  class CertificateError < StandardError; end

  class ResponseError < StandardError
    attr_reader :response

    def initialize(message, response)
      @response = response
      super(message)
    end
  end
end

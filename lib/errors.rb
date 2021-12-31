# frozen_string_literal: true

module Auth
  module Errors
    class Error < RuntimeError
    end

    class Processor < Auth::Errors::Error
    end

    class ProcessorHasNoSecret < Auth::Errors::Error
    end

    class ProcessorHasNoIssuer < Auth::Errors::Error
    end

    class Token < Auth::Errors::Error
    end

    class TokenMissing < Auth::Errors::Token
    end

    class TokenPayloadError < Auth::Errors::Token
    end

    class TokenExpired < Auth::Errors::TokenPayloadError
    end

    class TokenNotYetValid < Auth::Errors::TokenPayloadError
    end

    class TokenHasNoIssuer < Auth::Errors::TokenPayloadError
    end

    class TokenHasNoSubject < Auth::Errors::TokenPayloadError
    end

    class TokenHasNoIssuedAt < Auth::Errors::TokenPayloadError
    end

    class TokenHasNoExpiry < Auth::Errors::TokenPayloadError
    end

    class TokenIssuerIncorrect < Auth::Errors::TokenPayloadError
    end

    class TokenDecodeError < Auth::Errors::Token
    end

    class TokenTamperDetected < Auth::Errors::TokenDecodeError
    end

    class Client < Auth::Errors::Error
    end

    class ClientHasNoAuthServer < Auth::Errors::Client
    end

    class ClientHasNoClientId < Auth::Errors::Client
    end

    class ClientHasNoClientSecret < Auth::Errors::Client
    end

    class ClientHasNoBaseUri < Auth::Errors::Client
    end

    class Network < Auth::Errors::Error
    end

    class NetworkConnectionFailed < Auth::Errors::Network
    end
  end
end

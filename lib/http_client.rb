# frozen_string_literal: true

require "oauth2"

module Auth
  class HttpClient
    attr_reader :authenticated_client

    def initialize(
      client_id = nil,
      client_secret = nil,
      auth_server = nil,
      base_uri = nil,
      auth_client = OAuth2::Client
    )
      raise Auth::Errors::ClientHasNoClientId if client_id.nil?
      raise Auth::Errors::ClientHasNoClientSecret if client_secret.nil?
      raise Auth::Errors::ClientHasNoAuthServer if auth_server.nil?
      raise Auth::Errors::ClientHasNoBaseUri if base_uri.nil?

      @authenticated_client = nil

      site_url = URI.parse(auth_server)
      token_url = "#{site_url.path}/oauth/token"
      authorisation_url = "#{site_url.path}/oauth/token"
      site_url = "#{site_url.scheme}://#{site_url.host}:#{site_url.port}"

      @base_uri = base_uri
      @client =
        auth_client.new client_id,
                        client_secret,
                        auth_scheme: :request_body,
                        site: site_url,
                        token_url: token_url,
                        authorisation_url: authorisation_url,
                        raise_errors: false
    end

    def refresh
      @authenticated_client = @client.client_credentials.get_token
    end

    def refresh?
      @authenticated_client.nil? || @authenticated_client.expired?
    end

    def self.delegate(*methods)
      methods.each do |method_name|
        define_method(method_name) do |*args, &block|
          request method_name, *args, &block
        end
      end
    end

    delegate :get, :post, :put

    def request(method_name, *args, &block)
      refresh? && refresh

      args[0] = @base_uri + args[0]

      if @authenticated_client.respond_to? method_name
        response = @authenticated_client.send method_name, *args, &block
        if response.status == 401
          # a 401 here is assumed to be due to an expired token
          # otherwise, refreshing the token and calling again should make no difference to the ultimate response
          refresh
          response = @authenticated_client.send method_name, *args, &block
        end

        response
      end
    rescue Faraday::ConnectionFailed
      raise Auth::Errors::NetworkConnectionFailed
    end
  end
end

# frozen_string_literal: true

require "jwt"
require "uuid"
require "epb-auth-tools"
require "rack/test"
require "rspec"
require "webmock/rspec"
require "zeitwerk"

require_relative "stubs/oauth2_stub"

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../lib/")
loader.push_dir("#{__dir__}/../lib/sinatra")
loader.inflector.inflect("epb-auth-tools" => "Auth")

loader.setup

ENV["JWT_SECRET"] = "TestingSecretString"
ENV["JWT_ISSUER"] = "test.issuer"

RSpec::Matchers.define :be_a_valid_jwt_token do
  match do |actual|
    processor = Auth::TokenProcessor.new ENV["JWT_SECRET"], ENV["JWT_ISSUER"]
    _token = processor.process actual
    true
  rescue StandardError
    false
  end
end

RSpec::Matchers.define :be_a_valid_uuid do
  match { |actual| !UUID.validate(actual).nil? }
end

def uuid_generate
  uuid = UUID.new
  uuid.generate
end

def token_payload(payload)
  @jwt_issuer = ENV["JWT_ISSUER"]

  payloads = {
    incorrect_issuer_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': "incorrect.issuer",
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    expired_token: {
      'exp': Time.now.to_i - 3600,
      'iat': Time.now.to_i - 7200,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    token_without_expiry: {
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    premature_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i + 30 * 60,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    missing_issued_at_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    missing_sub_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    missing_issuer_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    valid_token_with_sup: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
      'sup': {
        'test': true,
      },
    },
    valid_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3],
    },
    valid_token_missing_scopes: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
    },
  }

  payloads[payload]
end

def token_generate(payload)
  @jwt_secret = ENV["JWT_SECRET"]

  JWT.encode token_payload(payload), @jwt_secret, "HS256"
end

# frozen_string_literal: true

require_relative 'sinatra/app'
require 'rack/test'

describe 'Integration::SinatraConditional' do
  include Rack::Test::Methods

  def app
    AppService
  end

  context 'when making an unauthenticated request to /' do
    let(:response) { get '/' }

    it 'returns a 401 status' do
      expect(response.status).to eq 401
    end

    it 'gives a TokenDecodeError Error' do
      expect(response.body).to include 'Auth::Errors::TokenDecodeError'
    end
  end

  context 'when making an authenticated request with a tampered token' do
    let(:response) do
      token = Auth::Token.new token_payload :valid_token
      jwt = token.encode ENV['JWT_SECRET']
      jwt = jwt.split('.')
      payload = JSON.parse Base64.decode64 jwt[1]
      payload['scopes'] = %w[admin:*]
      jwt[1] = Base64.encode64 payload.to_json

      header 'Authorization', 'Bearer ' + jwt.join('.')
      get '/'
    end

    it 'returns a 401 status' do
      expect(response.status).to eq 401
    end

    it 'gives a TokenTamperDetected Error' do
      expect(response.body).to include 'Auth::Errors::TokenTamperDetected'
    end
  end

  context 'when making an authenticated request to /' do
    let(:response) do
      token = Auth::Token.new token_payload :valid_token
      jwt = token.encode ENV['JWT_SECRET']

      header 'Authorization', 'Bearer ' + jwt
      get '/'
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end
  end
end
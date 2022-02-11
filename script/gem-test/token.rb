# frozen_string_literal: true

puts "$LOAD_PATH="
puts $LOAD_PATH

require "epb-auth-tools"

@jwt_issuer = "test.issuer"
jwt_secret = "thisisa3twocharactersecretstring"

def token_generate(secret)
  JWT.encode(
    {
      exp: Time.now.to_i + 60 * 60,
      iat: Time.now.to_i,
      iss: @jwt_issuer,
      sub: "epbr",
      scopes: %w[scope:1 scope:2 scope:3],
    },
    secret,
    "HS256",
  )
end

token_processor = Auth::TokenProcessor.new jwt_secret, @jwt_issuer
token = token_processor.process token_generate jwt_secret

exit 1 unless token.scope? "scope:1"

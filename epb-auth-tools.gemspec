# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "epb-auth-tools"
  s.version = "1.2.1"
  s.date = "2026-05-05"
  s.summary = "Tools for authentication and authorisation with JWTs and OAuth"
  s.homepage = "https://github.com/communitiesuk/epb-auth-tools"
  s.license = "MIT"
  s.authors = [
    "Lawrence Goldstien <lawrence.goldstien@madetech.com>",
    "Yusuf Sheikh <yusuf@madetech.com>",
    "Jaseera <jaseera@madetech.com>",
    "Kevin Keenoy <kevin.keenoy@levellingup.gov.uk>",
    "Douglas Greenshields <douglas.greenshields@levellingup.gov.uk>",
    "Aga Dufrat <aga.dufrat@levellingup.gov.uk>",
    "Abdal Warsame <abdal.warsame@communities.gov.uk>",
  ]

  s.required_ruby_version = ">= 4.0"
  s.metadata["rubygems_mfa_required"] = "true"

  s.files = %w[lib/epb-auth-tools.rb
               lib/errors.rb
               lib/http_client.rb
               lib/token.rb
               lib/token_processor.rb
               lib/sinatra/conditional.rb]
  s.require_paths = %w[lib]

  s.add_runtime_dependency "jwt", "~> 3.3"
  s.add_runtime_dependency "oauth2", "~> 2.1"
end

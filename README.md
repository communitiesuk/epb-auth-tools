# EPB Authentication and Authorisation Tools

This RubyGem provides a set of tools to use along with [communitiesuk/epb-auth-server](https://github.com/communitiesuk/epb-auth-server).
There are two primary components: middleware for validating JWTs in sinatra apps,
and a HTTP client that provides a mechanism for making authenticated requests.

Random edit 

## Getting set up

### Install

To install all required libs and other info, run `make install`.

### Testing

To test the gem, run `make test`.

### Syntax Cleanup

To ensure that all your code looks nice and conforms to the repo standards, run
`make format`.

## Sinatra Conditional Routing

The epb-auth-tools module has a sinatra conditional routing helper class.

To use this simply require `epb_auth_tools` and define the following in your
application class.

```ruby
# frozen_string_literal: true

require 'sinatra'
require 'epb-auth-tools'

class AppService < Sinatra::Base
  set(:jwt_auth) do
    condition do
      Auth::Sinatra::Conditional.process_request env
    rescue Auth::Errors::Error => e
      content_type :json
      halt 401, { error: e }.to_json
    end
  end

  get '/', jwt_auth: [] do
    content_type :json
    status 200
    { message: 'authenticated' }.to_json
  end
end
```

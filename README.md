# Cocoafish Ruby Client

This is a Ruby client for the Cocoafish server backand that can be used in your Ruby scripts and Ruby on Rails apps. For full documentation about the API methods that can be used through this gem, see the [Cocoafish REST API documentation](http://cocoafish.com/docs/rest). This has been developed and tested with Ruby 1.8.7/1.9.2 and Rails 3.0.5. Earlier versions of Ruby or Rails may not work.

## Setup

Cocoafish is currently in Private Beta. Before your app can access the Cocoafish API servers, you must:

1. Request a Beta invitation code at http://cocoafish.com/beta/signup
2. Use the Beta invitation code to create an account at http://cocoafish.com/signup
3. Register your app at http://cocoafish.com/apps to generate an app key, OAuth consumer key, and OAuth secret

## Installation

### Rails

For Rails 3, add the Cocoafish gem to your Gemfile:

    gem 'cocoafish'

and install with bundler:

    # bundle install

### Ruby

For plain Ruby manually install the Cocoafish gem:

    # sudo gem install cocoafish

Then include it in your scripts:

    require 'rubygems'
    require 'cocoafish'
    
## Usage

### Authenticating with Ccooafish

Find the OAuth consumer key and secret for your app at http://cocoafish.com/apps and use them to set the credentials so that your app can talk to the Cocoafish API servers.

    Cocoafish::Client.set_credentials('key', 'secret')

### Making Requests

Use the Cocoafish client http methods to store and retrive data with Cocoafish by passing a url path and optional parameters hash:

    result = Cocoafish::Client.post(path, params = {})
    result = Cocoafish::Client.get(path, params = {})
    result = Cocoafish::Client.put(path, params = {})
    result = Cocoafish::Client.delete(path, params = {})

The url path is the suffix of a [Cocoafish REST API](http://cocoafish.com/docs/rest) call such as:

    result = Cocoafish::Client.get("places/show.json", {:place_id => "4e10f444d0afbe4156000019"})
    result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish"})

### Processing Responses

Cocoafish API servers return data in JSON format:

    {
      "meta": {
        "status": "ok",
        "code": 200,
        "method_name": "createUser",
        "session_id": "6z4xBTs-cg1fL7U7RGVDSw_9vC8"
      },
      "response": {
        "users": [
          {
            "id": "4ec4c607356f4e12c8000035",
            "first_name": "Jane",
            "last_name": "User",
            "created_at": "2011-11-17T08:29:59+0000",
            "updated_at": "2011-11-17T08:29:59+0000",
            "email": "jane@cocoafish.com"
          }
        ]
      }
    }

The Ruby client library provides the response wrapped in an object accessible through dot notation:

    $ irb
    > result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish"})
    > puts result.response.users[0].id
    4ec4c870356f4e12c8000038
    > puts result.response.users[0].first_name
    Jane

Or, the original JSON reponse string can be accessed:

    > result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish"})
    > json_result = JSON.parse(result.json)
    > puts result.response.users[0].id
    4ec4c870356f4e12c8000038
    > puts json_result["response"]["users"][0]['first_name']
    Jane
    
The response code and message can be retreived through the meta:

    > puts result.meta.status
    ok
    > puts result.meta.code
    200
    > puts result.meta.method_name
    createUser

### Handling Errors

Errors returned from the Cocoafish API will be thrown as an exception. Wrap Cocoaifsh client calls in a begin/rescue block to capture and handle them gracefully.

    begin
      result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish"})
    rescue Cocoafish::CocoafishError => e
      puts "Login failed: #{e.message}"
    end

## Code Samples

### Checkin App Example

The following script shows how to perform actions required for a checkin app:

    require 'rubygems'
    require 'cocoafish'

    # set Oauth consumer key and secret from your app
    Cocoafish::Client.set_credentials("7z5w8Jcg3iUejPab9ugty15oacju8fSF", "Jxc18og2eq1G0Al9jAFoE3CUfCUdFS6L")

    # create a user which logs her in automatically
    result = Cocoafish::Client.post("users/create.json", {:email => "jane@cocoafish.com", :password => "cocoafish", :password_confirmation => "cocoafish", :first_name => "Jane", :last_name => "User"})

    # get the user's id
    user_id = result.response.users[0].id

    # create a photo
    result = Cocoafish::Client.post("photos/create.json", {:photo => "/Users/jane/Desktop/photo.jpg"})
    photo_id = result.response.photos[0].id

    # delete the user
    result = Cocoafish::Client.delete("users/delete.json")
  
## Additional APIs

For more examples of API usage see the [Cocoafish REST API](http://cocoafish.com/docs/rest) documentation.

## Copyright

Copyright (c) 2011 Cocoafish. See LICENSE.txt for further details.

## Support

For questions or comments about the Cocoafish Ruby client gem, or about Cocoafish in general, contact <info@cocoafish.com>.

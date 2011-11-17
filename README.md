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
    result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish", :password_confirmation => "cocoafish"})

### Processing Responses

Cocoafish API servers return data in JSON format:

        
  

The Ruby client library provides access to the raw JSON:

    result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish", :password_confirmation => "cocoafish"})
    puts result.users[0].id
    puts result.users[0].first_name
    
As well as providng the data wrapped in a Ruby Object with fields accessible through dot notation:

    
    



    result.

that can be accessed by

### Handling Errors

Errors returned from the Cocoafish API will be thrown as an exception. Wrap Cocoaifsh client calls in a begin/rescue block to 

## Examples

### Authenticating with Ccooafish

Find the OAuth consumer key and secret for you app from http://cocoafish.com/apps and use them to set the credentials so that your code can talk to the Cocoafish API servers.

    > Cocoafish::Client.set_credentials('token', 'secret')

### Logging In a User

    > response = Cocoafish::Client.post("users/login.json", {:login => "mike@cocoafish.com", :password => "pass"})
    > result.users[0].id
    => "4e10f444d0afbe4137000003"
    > result.users[0].first_name
    => "Mike"
   
### Creating a Photo

    > response = Cocoafish::Client.post("photos/create.json", {:user_id => "4e10f444d0afbe4137000003", :photo => "/tmp/photo.jpg"})
    > result.users[0].id
    => "4e10f444d0afbe4137000003"
    > result.users[0].first_name
    => "Mike"
  
### Other APIs

For more examples see: http://cocoafish.com/docs/rest

== Copyright

Copyright (c) 2011 Cocoafish. See LICENSE.txt for further details.

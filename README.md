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

Find the OAuth consumer key and secret for your app on the [Cocoafish app management site](http://cocoafish.com/apps) and use them to set the credentials so that your app can talk to the Cocoafish API servers.

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

    result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish"})
    puts result.response.users[0].id
     => 4ec4c870356f4e12c8000038
    puts result.response.users[0].first_name
     => Jane

Or, the original JSON reponse string can be accessed:

    result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish"})
    json_result = JSON.parse(result.json)
    puts result.response.users[0].id
     => 4ec4c870356f4e12c8000038
    puts json_result["response"]["users"][0]['first_name']
     => Jane
    
The response code and message can be retreived through the meta:

    puts result.meta.status
     => ok
    puts result.meta.code
     => 200
    puts result.meta.method_name
     => createUser

### Handling Errors

Errors returned from the Cocoafish API will be thrown as an exception. Wrap Cocoaifsh client calls in a begin/rescue block to capture and handle them gracefully.

    begin
      result = Cocoafish::Client.post("users/login.json", {:login => "jane@cocoafish.com", :password => "cocoafish"})
    rescue Cocoafish::CocoafishError => e
      puts "Login failed: #{e.message}"
    end

## Code Samples

### Checkin App Example

The following script shows how to perform actions required for a checkin app: create users, create places, checkin to places with photos, and search for checkins by location.

    require 'rubygems'
    require 'cocoafish'

    # set Oauth consumer key and secret from your app
    Cocoafish::Client.set_credentials("7z5w8Jcg3iUemGab9ugty15oacju8fSF", "Jxc18og2eq1G0Mg9jAFoE3CUfCUdFS6L")

    #  create a user which logs her in automatically
    result = Cocoafish::Client.post("users/create.json", {:email => "jane5@cocoafish.com", :password => "cocoafish", :password_confirmation => "cocoafish", :first_name => "Jane", :last_name => "User"})

    # create a place
    result = Cocoafish::Client.post("places/create.json", {:name => "Cocoafish HQ", :address => "156 2nd St", :city => "San Francisco", :state => "CA", :postal_code => "94107", :latitude => 37.787099, :longitude => -122.399101})
    place_1_id = result.response.places[0].id

    # checkin to the place with a photo and message
    result = Cocoafish::Client.post("checkins/create.json", {:message => "Working hard!", :photo => "/Users/mgoff/Desktop/atwork.jpg", "photo_sync_sizes[]" => "large_1024", :place_id => place_1_id})

    # create another place
    result = Cocoafish::Client.post("places/create.json", {:name => "Kingdom of Dumpling", :address => "1713 Taraval St", :city => "San Francisco", :state => "CA", :postal_code => "94116", :latitude => 37.742640, :longitude => -122.484597})
    place_2_id = result.response.places[0].id

    # checkin to the place with a photo and message
    result = Cocoafish::Client.post("checkins/create.json", {:message => "Eating some awesome Chinese dumplings!", :photo => "/Users/mgoff/Desktop/dumplings.jpg", "photo_sync_sizes[]" => "large_1024", :place_id => place_2_id})

    # search for checkins from my current location in Union Square
    result = Cocoafish::Client.get("checkins/search.json", {:latitude => 37.787930, :longitude => -122.407499})

    # loop through the results and print them out
    result.response.checkins.each_with_index do |checkin, index|
      puts "Checkin #{index}"
      puts "  User:    #{checkin.user.first_name} #{checkin.user.last_name}"
      puts "  Place:   #{checkin.place.name}"
      puts "  Message: #{checkin.message}"
      puts "  Photo:   #{checkin.photo.urls.large_1024}\n\n"
    end
    
Running this script performs the actions and shows the nearby checkins along with URLs for the uploaded checkin photos:

    Checkin 0
      User:    Jane User
      Place:   Cocoafish HQ
      Message: Working hard!
      Photo:   http://storage.cocoafish.com/13B5z6WqEMRUVsqdmn1vudovz3RTexmn/photos/c9/39/4ec4e189356f4e12c80000c2/atwork_large_1024.jpg

    Checkin 1
      User:    Jane User
      Place:   Kingdom of Dumpling
      Message: Eating some awesome Chinese dumplings!
      Photo:   http://storage.cocoafish.com/13B5z6WqEMRUVsqdmn1vudovz3RTexmn/photos/c9/39/4ec4db91356f4e12c8000055/dumplings_large_1024.jpg

## Additional APIs

For more examples of API usage see the [Cocoafish REST API](http://cocoafish.com/docs/rest) documentation.

## Copyright

Copyright (c) 2011 Cocoafish. See LICENSE.txt for further details.

## Support

For questions or comments about the Cocoafish Ruby client gem, or about Cocoafish in general, contact <info@cocoafish.com>.

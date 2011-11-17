# cocoafish

This is a Ruby client for the Cocoafish server backand that can be used in your Ruby scripts and Ruby on Rails apps. For full documentation about the API methods that can be used through this gem, see the [Cocoafish REST API documentation](http://cocoafish.com/docs/rest). This has been developed and tested with Ruby 1.8.7/1.9.2 and Rails 3.0.5. Earlier versions of Ruby or Rails may not work.

## Setup

Before your app can access the Cocoafish API servers, you must:

1. Request a Beta invitation code at http://cocoafish.com/beta/signup
2. Use the Beta invitation code to create an account at http://cocoafish.com/signup
3. Register your app at http://cocoafish.com/apps to generate an app key, OAuth consumer key, and OAuth secret

## Installation

For Rails 3, add this to your Gemfile:

  gem 'cocoafish'
  
For plain Ruby:

  # sudo gem install cocoafish

## Examples

Start by setting your OAuth credentials for your app which can be found at http://cocoafish.com/apps:

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

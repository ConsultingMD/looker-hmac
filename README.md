# Grnds::Looker::Hmac

A simple looker.com authentication code helper for Grandrounds

## Installation

Add this line to your application's Gemfile:

    gem 'grnds-looker-hmac'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grnds-looker-hmac

## Usage

    #first set your LOOKER_EMBED_SECRET env var

    config = {
      :host => 'grandroundsstage.looker.com',
      :embed_path => '/embed/sso/dashboards/uat/uat_01',
      :path_root => '/login/embed/',
      :external_user_id => '57',
      :first_name => 'Kenneth',
      :last_name => 'Berland',
      :permissions => ["see_dashboards", "see_looks", "access_data"],
      :models => ['uat'],
      :session_length => 1.day.to_i,
    }

    signer = Grnds::Looker::Hmac::SignedUrlGenerator.new(config)
    signedUrl = signer.getUrl

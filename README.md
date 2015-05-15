# TransilienRealtime

Query SNCF Transilien API Temps Réel to get the next trains from your station, eventually toward an other station.

Note: you need to request credentials from SNCF Open Data to use this API and so this gem : https://ressources.data.sncf.com/explore/dataset/api-temps-reel-transilien/?tab=metas

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transilien_realtime'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transilien_realtime

## Usage

```ruby
require 'transilien_realtime'

tr = TransilienRealtime::Base.new(user: "MyAPIUser" pwd: "MyAPIPwd") # you can use ENV['RTT_API_USER'] and ENV['RTT_API_PWD'] instead
=> #<TransilienRealtime::Base:0x007f945d941698 @pwd="MyAPIPwd", @target=:production, @user="MyAPIUser">
tr.next(from: '87384008', to: '87381798')
=> #<TransilienRealtime::Base:0x007f945d941698
 @body=#<HTTP::Response::Body:3fca2e983734 @streaming=true>,
 @content="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<passages gare=\"87384008\">\r\n<train><date mode=\"R\">15/05/2015 14:12</date>\r\n<num>136891</num>\r\n<miss>MOCA</miss>\r\n<term>87381509</term>\r\n</train>\r\n</passages>\r\n",
 @pwd="MyAPIPwd",
 @response=#<HTTP::Response/1.1 200 OK {"Date"=>"Fri, 15 May 2015 12:06:56 GMT", "Content-Type"=>"application/vnd.sncf.transilien.od.depart+xml; vers=1.0", "Cache-Control"=>"no-cache", "Connection"=>"close"}>,
 @target=:production,
 @user="MyAPIUser">
tr.trains
=> [#<TransilienRealtime::Train:0x007f945dcc4770 @departure_at=2015-05-15 16:12:00 +0200, @mission="MOCA", @numero="136891", @terminus="87381509">]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/transilien_realtime/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

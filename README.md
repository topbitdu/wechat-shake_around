# Wechat Shake Around 微信摇周边库

[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/wechat-shake_around.svg)](https://badge.fury.io/rb/wechat-shake_around)

The Wechat Shake Around Library is a code base to call the Wechat Shake Around APIs.
微信摇周边库用于调用[微信摇周边API](http://mp.weixin.qq.com/wiki/19/9fe9fdbb50fee9f9660438c551142ccf.html)。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wechat-shake_around'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wechat-shake_around

## Usage

[Get Beacon & PoI & Page & Shaker 获取摇周边的设备及用户信息](http://mp.weixin.qq.com/wiki/3/34904a5db3d0ec7bb5306335b8da1faf.html) 
```ruby
response = ::Wechat::ShakeAround::Shaking.load access_token, params[:ticket]
if response.present? && 0==response['errcode']
  page_id = response['page_id']
  open_id = response['openid']
  poi_id  = response['poi_id']
  beacon  = response['beacon_info']
  beacon_distance = beacon['distance']
  beacon_uuid     = beacon['uuid']
  beacon_major    = beacon['major']
  beacon_minor    = beacon['minor']
end


```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/topbitdu/wechat-shake_around. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


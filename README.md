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

### Handle the Callback of Shaking 处理摇周边行为的回调
[Get Beacon & PoI & Page & Shaker 获取摇周边的设备及用户信息](http://mp.weixin.qq.com/wiki/3/34904a5db3d0ec7bb5306335b8da1faf.html) 
```ruby
response = Wechat::ShakeAround::Shaking.load access_token, params[:ticket]
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

### Apply the Device IDs 申请Beacon设备ID
[Apply Beacon Device IDs 申请设备ID](http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E7.94.B3.E8.AF.B7.E8.AE.BE.E5.A4.87ID)
```ruby
quantity = 500
reason   = 'Test Purpose'
comment  = 'Some Mall' # optional
poi_id   = nil         # optional Some PoI ID
response = Wechat::ShakeAround::Apply.create access_token, quantity, apply_reason, comment, poi_id
if response.present? && 0==response['errcode']
  apply_id      = response['data']['apply_id']
  audit_status  = response['data']['audit_status']
                  # 0：审核未通过、1：审核中、2：审核已通过
  audit_comment = response['data']['audit_comment']
else
  # Show response['errmsg']
end
```

[Query the Status of Application of Beacon Device IDs 查询设备ID申请审核状态](http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E6.9F.A5.E8.AF.A2.E8.AE.BE.E5.A4.87ID.E7.94.B3.E8.AF.B7.E5.AE.A1.E6.A0.B8.E7.8A.B6.E6.80.81)
```ruby
response = Wechat::ShakeAround::Apply.load access_token, apply_id
if response.present? && 0==response['errcode']
  apply_time    = response['data']['apply_time']
                  # 提交申请的时间戳
  audit_status  = response['data']['audit_status']
                  # 0：审核未通过、1：审核中、2：审核已通过
  audit_comment = response['data']['audit_comment']
  audit_time    = response['data']['audit_time']
                  # 确定审核结果的时间戳，若状态为审核中，则该时间值为0
else
  # Show response['errmsg']
end
```

### Manage the Beacon Devices 管理Beacon设备信息
[Get Beacon information by Batch 查询设备列表](http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E6.9F.A5.E8.AF.A2.E8.AE.BE.E5.A4.87.E5.88.97.E8.A1.A8)
```ruby
offset   = 40
limit    = 20
apply_id = nil
response = Wechat::ShakeAround::Beacon.index access_token, offset, limit, apply_id
if response.present? && 0==response['errcode']
  total_count = response['data']['total_count']
  response['data']['devices'].each do |device|
    device_id        = device['device_id']
    uuid             = device['uuid']
    major            = device['major']
    minor            = device['minor']
    status           = device['status']
                       # 0：未激活，1：已激活
    last_active_time = device['last_active_time']
                       # 设备最近一次被摇到的日期（最早只能获取前一天的数据）；新申请的设备该字段值为0 
    poi_id           = device['poi_id']
                       # 设备关联的门店ID，关联门店后，在门店1KM的范围内有优先摇出信息的机会
  end
else
  # Show response['errmsg']
end
```

[Get Beacon information 查询设备](http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E6.9F.A5.E8.AF.A2.E8.AE.BE.E5.A4.87.E5.88.97.E8.A1.A8)
```ruby
device_id = { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }
# or device_id = <INTEGER>
response  = Wechat::ShakeAround::Beacon.load access_token, device_id
if response.present? && 0==response['errcode']
  total_count = response['data']['total_count']
  response['data']['devices'].each do |device|
    device_id        = device['device_id']
    uuid             = device['uuid']
    major            = device['major']
    minor            = device['minor']
    status           = device['status']
                       # 0：未激活，1：已激活
    last_active_time = device['last_active_time']
                       # 设备最近一次被摇到的日期（最早只能获取前一天的数据）；新申请的设备该字段值为0 
    poi_id           = device['poi_id']
                       # 设备关联的门店ID，关联门店后，在门店1KM的范围内有优先摇出信息的机会
  end
else
  # Show response['errmsg']
end
```

[Update Beacon information 编辑设备信息](http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E7.BC.96.E8.BE.91.E8.AE.BE.E5.A4.87.E4.BF.A1.E6.81.AF)
```ruby
device_id = { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }
# or device_id = <INTEGER>
response  = Wechat::ShakeAround::Beacon.update access_token, device_id, comment
if response.present? && 0==response['errcode']
  # Do something more...
else
  # Show response['errmsg']
end
```

### Manage the Beacon Device Groups 管理Beacon设备分组
[Get Groups by Batch 查询分组列表](http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.9F.A5.E8.AF.A2.E5.88.86.E7.BB.84.E5.88.97.E8.A1.A8)
```ruby
response = Wechat::ShakeAround::Group.index access_token, offset, limit
if response.present? && 0==response['errcode']
  total_count = response['data']['total_count']
  response['data']['groups'].each do |group|
    group_id   = group['group_id']
    group_name = group['group_name']
  end
else
  # Show response['errmsg']
end
```

[Get Group per ID 查询分组详情](http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.9F.A5.E8.AF.A2.E5.88.86.E7.BB.84.E8.AF.A6.E6.83.85)
```ruby
response = Wechat::ShakeAround::Group.load access_token, group_id, offset, limit
if response.present? && 0==response['errcode']
  group_id    = response['data']['group_id']
  group_name  = response['data']['group_name']
  total_count = response['data']['total_count']
  response['data']['devices'].each do |device|
    device_id = device['device_id']
    uuid      = device['uuid']
    major_id  = device['major_id']
    minor_id  = device['minor_id']
    comment   = device['comment']
    poi_id    = device['poi_id']
  end
else
  # Show response['errmsg']
end
```

[Delete Group 删除分组](http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E5.88.A0.E9.99.A4.E5.88.86.E7.BB.84)
```ruby
response = Wechat::ShakeAround::Group.destroy access_token, group_id
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

[Update Group 编辑分组信息](http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E7.BC.96.E8.BE.91.E5.88.86.E7.BB.84.E4.BF.A1.E6.81.AF)
```ruby
response = Wechat::ShakeAround::Group.update access_token, group_id, name
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

[Create Group 新增分组](http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.96.B0.E5.A2.9E.E5.88.86.E7.BB.84)
```ruby
response = Wechat::ShakeAround::Group.create access_token, name
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

### Manage Beacon Device Group Relations 管理Beacon设备分组关系
[Create Device Group Relation 新增设备分组关联](http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.B7.BB.E5.8A.A0.E8.AE.BE.E5.A4.87.E5.88.B0.E5.88.86.E7.BB.84)
```ruby
response = Wechat::ShakeAround::DeviceGroupRelation.create access_token, device_id, group_id
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

[Destroy Device Group Relation 删除设备分组关联](http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E4.BB.8E.E5.88.86.E7.BB.84.E4.B8.AD.E7.A7.BB.E9.99.A4.E8.AE.BE.E5.A4.87)
```ruby
response = Wechat::ShakeAround::DeviceGroupRelation.destroy access_token, device_id, group_id
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

### Manage Pages 管理页面
[Get Pages by Batch 获取页面列表](http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E6.9F.A5.E8.AF.A2.E9.A1.B5.E9.9D.A2.E5.88.97.E8.A1.A8)
```ruby
response = Wechat::ShakeAround::Page.index access_token, offset, limit
if response.present? && 0==response['errcode']
  total_count = response['data']['total_count']
  response['data']['pages'].each do |page|
    comment     = page['comment']     # 页面的备注信息
    description = page['description'] # 在摇一摇页面展示的副标题
    icon_url    = page['icon_url']    # 在摇一摇页面展示的图片
    page_id     = page['page_id']     # 摇周边页面唯一ID 
    page_url    = page['page_url']    # 跳转链接
    title       = page['title']       # 在摇一摇页面展示的主标题
  end
else
  # Show response['errmsg']
end
```

[Get Page per ID 获取页面详情](http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E6.9F.A5.E8.AF.A2.E9.A1.B5.E9.9D.A2.E5.88.97.E8.A1.A8)
```ruby
response = Wechat::ShakeAround::Page.load access_token, page_id
if response.present? && 0==response['errcode']
  total_count = response['data']['total_count']
  page        = response['data']['pages'][0]
  comment     = page['comment']     # 页面的备注信息
  description = page['description'] # 在摇一摇页面展示的副标题
  icon_url    = page['icon_url']    # 在摇一摇页面展示的图片
  page_id     = page['page_id']     # 摇周边页面唯一ID 
  page_url    = page['page_url']    # 跳转链接
  title       = page['title']       # 在摇一摇页面展示的主标题
else
  # Show response['errmsg']
end
```

[Destroy Page per ID 删除页面](http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E5.88.A0.E9.99.A4.E9.A1.B5.E9.9D.A2)
```ruby
response = Wechat::ShakeAround::Page.destroy access_token, page_id
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

[Update Page per ID 编辑页面信息](http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E7.BC.96.E8.BE.91.E9.A1.B5.E9.9D.A2.E4.BF.A1.E6.81.AF)
```ruby
response = Wechat::ShakeAround::Page.update access_token, page_id, title, description, comment, page_link, icon_link
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

[Create Page 新增页面](http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html#.E6.96.B0.E5.A2.9E.E9.A1.B5.E9.9D.A2)
```ruby
response = Wechat::ShakeAround::Page.update access_token, title, description, comment, page_link, icon_link
if response.present? && 0==response['errcode']
  page_id = response['data']['page_id']
else
  # Show response['errmsg']
end
```

### Manage Beacon Device Page Relations 管理Beacon设备页面关系
[Destroy Beacon Page Relation 删除Beacon页面关系](http://mp.weixin.qq.com/wiki/12/c8120214ec0ba08af5dfcc0da1a11400.html)
device_id 可以是整数或者Hash结构：{ uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }。
```ruby
response = Wechat::ShakeAround::BeaconPageRelation.destroy access_token, device_id, page_id
if response.present? && 0==response['errcode']
  # Do something more
else
  # Show response['errmsg']
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/topbitdu/wechat-shake_around. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


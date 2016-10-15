require 'jsonclient'

class Wechat::ShakeAround::DeviceGroupRelation

  extend Wechat::Core::Common
  extend ::Wechat::ShakeAround::Common

  # 从分组中移除设备
  # http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E4.BB.8E.E5.88.86.E7.BB.84.E4.B8.AD.E7.A7.BB.E9.99.A4.E8.AE.BE.E5.A4.87
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  def self.destroy(access_token, device_id, group_id)

    assert_present! :access_token, access_token
    assert_present! :device_id, device_id

    device_identifier = normalize_device_id device_id
    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/device/group/deletedevice?access_token=#{access_token}",
      {
        group_id:           group_id.to_i,
        device_identifiers: [ device_identifier ]
      }
    message.body
  end

  # 添加设备到分组
  # http://mp.weixin.qq.com/wiki/10/9f6b498b6aa0eb5ef6b9ab5a70cc8fba.html#.E6.B7.BB.E5.8A.A0.E8.AE.BE.E5.A4.87.E5.88.B0.E5.88.86.E7.BB.84
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  # 每个分组能够持有的设备上限为10000，并且每次添加操作的添加上限为1000。
  def self.create(access_token, device_id, group_id)

    assert_present! :access_token, access_token
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    device_identifier = normalize_device_id device_id
    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/device/group/adddevice?access_token=#{access_token}",
      {
        group_id:           group_id.to_i,
        device_identifiers: [ device_identifier ]
      }
    message.body
  end

end
